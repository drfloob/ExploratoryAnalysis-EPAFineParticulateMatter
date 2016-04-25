## plot4.R, by Adam J Heller, 2016.04.24
## 
## Problem Statement: Across the United States, how have emissions from coal
## combustion-related sources changed from 1999–2008?

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

coalSCCDF <- SCC[grep("coal", SCC$Short.Name, ignore.case = T), ]
coalSCCDF <- coalSCCDF[grep("comb", coalSCCDF$Short.Name, ignore.case = T),]
coalData <- NEI %>% filter(SCC %in% as.character(coalSCCDF$SCC))
coalData <- coalData %>% group_by(year) %>% summarize(total=sum(Emissions))

png(file="plot4.png", bg="white")
par(mar=c(5,5,3,2))
with(coalData, {
    plot(year, total, type="p", pch=21,
         main="US Coal Combustion Emissions, PM2.5, 1999-2008",
         ylab = "Total Emissions (tons of PM2.5)")
    abline(lm(total ~ year), lwd=2, col="blue")
    legend("bottomleft", col="blue", lwd=2, legend = c("decreasing"))
})
dev.off()
