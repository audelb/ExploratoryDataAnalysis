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

#Q6 : Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. 
#Which city has seen greater changes over time in motor vehicle emissions?
MotorVehicle <- SCC[grepl("vehicle", SCC$EI.Sector, ignore.case = TRUE),]
BaltimoreLA <- NEI[NEI$fips == "24510" | NEI$fips == "06037",]
merge <- merge(BaltimoreLA, MotorVehicle, by = "SCC")
aggBalLAMotor <- ddply(merge, c("fips", "year"),summarise,total=sum(Emissions))
aggBalLAMotor$City <- ifelse(aggBalLAMotor$fips == "24510","Baltimore City", "Los Angeles City")
png(file = "./plot6.png")
p <- ggplot(data = aggBalLAMotor,aes(x = reorder(City,total),y = total)) + 
  theme_minimal() +
  geom_bar(stat = "identity", position = "dodge", aes(fill = as.character(year))) + 
  geom_text(position = position_dodge(width = 0.9), size = 3, vjust = -0.5, aes(label = round(total, digits = 0), group = as.character(year) )) + 
  labs(title = "Comparison of total PM2.5 emission \n between Baltimore and LA by years", y = "PM2.5 emitted (tons)", x = "Cities", fill = "Years")
grid.newpage()
footnote <- "The total motor emission in Baltimore City decreased between 1999 and 2008, \n for Los Angeles, the emissions increased between between 1999 and 2008, \n the only decrease (in LA) is between 2005 and 2008 "
g <- arrangeGrob(p, bottom = textGrob(footnote, x = 0, hjust = -0.01, vjust = 0.1, gp = gpar(fontsize = 10, col="blue")))
grid.draw(g)
dev.off()

setwd("../")