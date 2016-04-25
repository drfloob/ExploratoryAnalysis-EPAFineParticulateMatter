## plot2.R, by Adam J Heller, 2016.04.24
## 
## Problem Statement: Have total emissions from PM2.5 decreased in the Baltimore
## City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting
## system to make a plot answering this question.

library(dplyr)

zipFile <- "pm25-data.zip"
if (!file.exists(zipFile)) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  destfile = zipFile, method = "libcurl")
    unzip(zipfile = zipFile)
}

NEI <- readRDS("summarySCC_PM25.rds")

baltNEI <- NEI %>% filter(fips=="24510") %>% group_by(year) %>% summarize(total=sum(Emissions))

png(file="plot2.png", bg="white")
par(mar=c(5,5,3,2))
with(baltNEI, {
    plot(year, total, type="p", pch=21,
         main="Total Baltimore City, MD Emissions of PM2.5, 1999-2008",
         ylab = "Total Emissions (tons of PM2.5)")
    abline(lm(total ~ year), lwd=2, col="blue")
    legend(2005.3, 3320, col="blue", lwd=2, legend = c("decreasing"))
})
dev.off()