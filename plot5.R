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

#Q5 : How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
MotorVehicle <- SCC[grepl("vehicle", SCC$EI.Sector, ignore.case = TRUE),]
Baltimore <- NEI[NEI$fips == "24510",]
merge <- merge(Baltimore,MotorVehicle, by = "SCC")
aggMotorBal <- aggregate(Emissions ~ year, merge, sum)
png(file = "./plot5.png")
ggplot(data=aggMotorBal, aes(x=year, y=Emissions, group=1)) + 
  theme_minimal() +
  geom_line() + 
  geom_point() + 
  geom_text(aes(label = as.character(round(as.numeric(Emissions), digits = 0))), hjust=-0.5, vjust=-1, size=3) + 
  labs(title = "Total PM2.5 emission from motor vehicle \n in Baltimore by years", y = "PM2.5 emitted (tons)", x = "Years")
dev.off()

setwd("../")