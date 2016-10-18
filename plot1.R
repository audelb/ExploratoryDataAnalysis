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

#Q1 : Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
agg <- aggregate(Emissions ~ year, NEI, sum)
agg$K <- agg$Emissions/1000
png(file = "./plot1.png")
barplot(agg$K, names.arg = agg$year,main = "Total PM2.5 emission by years",ylab = "PM2.5 emitted (kilotons)")
text(2.5, 1000, "Yes, the total emission from PM2.5 decreased", col = "blue")
dev.off()

setwd("../")