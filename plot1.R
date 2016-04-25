## plot1.R, by Adam J Heller, 2016.04.24
## 
## Problem Statement: Have total emissions from PM2.5 decreased in the United 
## States from 1999 to 2008? Using the base plotting system, make a plot showing
## the total PM2.5 emission from all sources for each of the years 1999, 2002, 
## 2005, and 2008.

library(dplyr)

zipFile <- "pm25-data.zip"
if (!file.exists(zipFile)) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  destfile = zipFile, method = "libcurl")
    unzip(zipfile = zipFile)
}

NEI <- readRDS("summarySCC_PM25.rds")

yearGrpNEI <- NEI %>% group_by(year) %>% summarize(total=sum(Emissions))

png(file="plot1.png", bg="white")
par(mar=c(5,5,3,2))
with(yearGrpNEI, {
    plot(year, total, type="p", pch=21,
         main="Total US Emissions of PM2.5, 1999-2008",
         ylab = "Total Emissions (tons of PM2.5)")
    abline(lm(total ~ year), lwd=2, col="blue")
    legend(2005, 7e+06, col="blue", lwd=2, legend = c("decreasing"))
})
dev.off()