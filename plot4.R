# function to check if a package is installed
pckCheck <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
  library(x, character.only = TRUE)
}

# install and call libraries
pckCheck("ggplot2")
pckCheck("plyr")
pckCheck("grid")
pckCheck("gridExtra")

# download sources
if (!file.exists("./dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./dataset.zip")
}
if (!file.exists("./Fine particulate matter/")) {
  unzip("./dataset.zip", exdir = "./Fine particulate matter")
}

# Load sources
setwd("./Fine particulate matter/")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Q4 : Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
CoalCombustion <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE) & grepl("combustion", SCC$SCC.Level.One, ignore.case = TRUE),]
merge <- merge(NEI,CoalCombustion, by = "SCC")
aggCoalCombustion <- aggregate(Emissions ~ year, merge, sum)
aggCoalCombustion$K <- aggCoalCombustion$Emissions/1000
png(file = "./plot4.png")
barplot(aggCoalCombustion$K , names.arg = aggCoalCombustion$year,main = "Total PM2.5 emission from coal combustion by years",ylab = "PM2.5 emitted (Kilotons)")
dev.off()

setwd("../")