## plot3.R, by Adam J Heller, 2016.04.24
## 
## Problem Statement: Of the four types of sources indicated by the type (point,
## nonpoint, onroad, nonroad) variable, which of these four sources have seen
## decreases in emissions from 1999–2008 for Baltimore City? Which have seen
## increases in emissions from 1999–2008? Use the ggplot2 plotting system to
## make a plot answer this question.

library(dplyr)
library(ggplot2)

zipFile <- "pm25-data.zip"
if (!file.exists(zipFile)) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  destfile = zipFile, method = "libcurl")
    unzip(zipfile = zipFile)
}

NEI <- readRDS("summarySCC_PM25.rds")

baltNEI <- NEI %>% filter(fips=="24510") %>% 
    group_by(year, type) %>% 
    summarize(total=sum(Emissions))
lms <- split(baltNEI, factor(baltNEI$type)) %>% 
    sapply(function(x){lm(total ~ year, x)})
baltNEI$decreasing <- sapply(lms[,baltNEI$type][1,], function(x){x[2] < 0})

png("plot3.png", bg="white", width = 800, height = 400)
ggplot(data = baltNEI, aes(x=year, y=total)) + 
    geom_point() + 
    geom_smooth(method="lm", aes(color=decreasing)) + 
    facet_grid(. ~ type) +
    ggtitle("Baltimore City, MD: Total emissions by type, 1999-2008") +
    labs(y="Total Emissions (tons of PM2.5)")
dev.off()