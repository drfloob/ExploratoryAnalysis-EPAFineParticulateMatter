## plot6.R, by Adam J Heller, 2016.04.24
## 
## Problem Statement: Compare emissions from motor vehicle sources in Baltimore
## City with emissions from motor vehicle sources in Los Angeles County,
## California (fips == "06037"). Which city has seen greater changes over time
## in motor vehicle emissions?

library(dplyr)
library(ggplot2)

zipFile <- "pm25-data.zip"
if (!file.exists(zipFile)) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  destfile = zipFile, method = "libcurl")
    unzip(zipfile = zipFile)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltNEI <- NEI %>% filter(fips=="24510") #%>% group_by(year) %>% summarize(total=sum(Emissions))
baltVehicSCC <- filter(SCC, SCC %in% unique(baltNEI$SCC))
baltVehicSCC <- baltVehicSCC[grep("vehic", baltVehicSCC$Short.Name, ignore.case = T),]
baltNEI <- filter(baltNEI, SCC %in% baltVehicSCC$SCC)

laNEI <- NEI %>% filter(fips=="06037") #%>% group_by(year) %>% summarize(total=sum(Emissions))
laVehicSCC <- filter(SCC, SCC %in% unique(laNEI$SCC))
laVehicSCC <- laVehicSCC[grep("vehic", laVehicSCC$Short.Name, ignore.case = T),]
laNEI <- filter(laNEI, SCC %in% laVehicSCC$SCC)

# NOTE: SCC includes parent categories like "Urbant Interstate: Total" and 
# "Urban Interstate: Exhaust" that overlap each other. This is an issue in the 
# Los Angeles data. For example, look at the output of:
# 
# filter(NEI, fips=="06037") -> x; x[grep("^22300013", x$SCC), ]
# 
# Notice the Emissions outliers at the top. They correspond to "Total" entries 
# that are comprised of other emissions entries in this list. To sum them all 
# would be double-counting emissions. And I'd bet good money that's what most 
# everyone else is doing.
# 
# Unfortunately, not all motor vehicle categories have totals, and teasing out 
# an accurate set of categories to look at seems like a monumental task. I think
# this is beyond the scope of this project. If we are lucky, city reporting has 
# been self-consistent over time, which means the trend lines will still be 
# going in the right direction, but they'll be exaggerated/scaled in the case of
# double counting. Comparing the slopes of their trends, as this question asks
# us to do, will probably be misleading.
# 
# Eliminating "total" lines in an attempt to correct for this unfortunately 
# wiped out all Baltimore data for 1999 and 2008. Wiping out non-Total entries 
# would likely fail to count some valid emissions. This project requires a lot 
# of in-depth research to do well.

baltNEI$city <- "Baltimore City, MD"
laNEI$city <- "Los Angeles, CA"

merged <- rbind(baltNEI, laNEI)
merged <- merged %>% group_by(city, year) %>% summarize(total=sum(Emissions))

png(file="plot6.png", bg="white", width=800, height=400)
par(mar=c(5,5,3,2))
ggplot(data = merged, aes(x=year, y=total, color=city)) +
    geom_point() + 
    geom_smooth() + 
    ggtitle("Comparing vehicle emissions for Baltimore City, MD and Los Angeles, CA") + 
    ylab("Total Emissions (tons of PM2.5)")
dev.off()