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

# NOTE: SCC includes parent categories like "All Road Types" that would 
# duplicate data counting in sums. Thankfully, Baltimore doesn't have any of
# these SCCs in the NEI data.

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