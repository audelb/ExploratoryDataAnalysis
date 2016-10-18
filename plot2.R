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

#Q2 : Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?
Baltimore <- NEI[NEI$fips == "24510",]
aggBal <- aggregate(Emissions ~ year, Baltimore, sum)
png(file = "./plot2.png")
barplot(aggBal$Emissions, names.arg = aggBal$year,main = "Total PM2.5 emission in Baltimore by years",ylab = "PM2.5 emitted (tons)")
text(2.5, 500, "The total emission of PM2.5 in Baltimore City decreased \n between 1999 and 2008, but it increased between 2002 and 2005", col = "blue", )
dev.off()

setwd("../")