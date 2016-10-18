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

#Q3 : Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008?
Baltimore <- NEI[NEI$fips == "24510",]
aggBalType <- ddply(Baltimore, c("type", "year"),summarise,total=sum(Emissions))
png(file = "./plot3.png")
p <- ggplot(data = aggBalType,aes(x = reorder(type,total),y = total)) + 
  geom_bar(stat = "identity", position = "dodge", aes(fill = as.character(year))) + 
  labs(title = "Total PM2.5 emission in Baltimore by years and types", y = "PM2.5 emitted (tons)", x = "Types", fill = "Years")
grid.newpage()
footnote <- "The total emission of PM2.5 in Baltimore City decreased between 1999 and 2008 for on-road, \n non-road, nonpoint and increased for point"
g <- arrangeGrob(p, bottom = textGrob(footnote, x = 0, hjust = -0.01, vjust = 0.1, gp = gpar(fontsize = 10, col="blue")))
grid.draw(g)
dev.off()

setwd("../")