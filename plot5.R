## plot5.R, by Adam J Heller, 2016.04.24
## 
## Problem Statement: How have emissions from motor vehicle sources changed from
## 1999–2008 in Baltimore City?

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
vehicSCC <- filter(SCC, SCC %in% unique(baltNEI$SCC))
vehicSCC <- vehicSCC[grep("vehic", vehicSCC$Short.Name, ignore.case = T),]$SCC
baltNEI <- filter(baltNEI, SCC %in% vehicSCC)

# NOTE: SCC includes summary categories like "Urban Local: Total" that duplicate
# data in categories like "Urban Local: Brake Wear". The trouble is we can't 
# just eliminate totals or individual entries since some years only have total, 
# and others only have entries. If at least the city is self-consistent with how
# and when they include "Total" entries, the trend lines will be in the right
# direction, but skewed/exaggerated.

baltNEI <- baltNEI %>% group_by(year) %>% summarize(total=sum(Emissions))

png(file="plot5.png", bg="white")
par(mar=c(5,5,3,2))
with(baltNEI, {
    plot(year, total, type="p", pch=21,
         main="Motor Vehicle Emissions for Baltimore, MD, PM2.5, 1999-2008",
         ylab = "Total Emissions (tons of PM2.5)")
    abline(lm(total ~ year), lwd=2, col="blue")
    legend("topright", col="blue", lwd=2, legend = c("decreasing"))
})
dev.off()