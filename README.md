# ExploratoryAnalysis-EPAFineParticulateMatter
A series of plots exploring ambient air pollution data (for the Johns Hopkins Data Science program)

## Assignment

You must address the following questions and tasks in your exploratory
analysis. For each question/task you will need to make a single
plot. Unless specified, you can use any plotting system in R to make
your plot.

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?


## Files

`plot[1-6].R` generate the `plot[1-6].png` result files, relying on `etl.R` to download and read in the required data.


## Notes

The data for this project can be manually downloaded [here](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip), but the data is from the [EPA National Emissions Inventory](https://www.epa.gov/air-emissions-inventories).

## Codebook

The zip file contains two files:

### PM2.5 Emissions Data (summarySCC_PM25.rds)

This file contains a data frame with all of the PM2.5 emissions data
for 1999, 2002, 2005, and 2008. For each year, the table contains
number of tons of PM2.5 emitted from a specific type of source for the
entire year.

* `fips`: A five-digit number (represented as a string) indicating the U.S. county
* `SCC`: The name of the source as indicated by a digit string (see source code classification table)
* `Pollutant`: A string indicating the pollutant
* `Emissions`: Amount of PM2.5 emitted, in tons
* `type`: The type of source (point, non-point, on-road, or non-road)
* `year`: The year of emissions recorded

### Source Classification Code Table (Source_Classification_Code.rds)

This table provides a mapping from the SCC digit strings in the
Emissions table to the actual name of the PM2.5 source.