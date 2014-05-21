## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### libraries
library(data.table)
library(ggplot2)
library(quantmod)

# Question 6
# 6) Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
#    sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes
#    over time in motor vehicle emissions?
data <- merge( data.table(NEI), data.table(SCC), by = "SCC", all=TRUE)
# select only Baltimore and LA
q6 <- data[ fips %in% c("24510", "06037"), ]
# get on road sector
q6 <- q6[ grep("^mobile - on-road", EI.Sector, ignore.case=TRUE), ]
# get sum(Emissions) by year for each city
q6 <- rbind(
   cbind(q6[fips == "24510", list(sum=sum(Emissions)), by=list(year)], city = "Baltimore"),
   cbind(q6[fips == "06037", list(sum=sum(Emissions)), by=list(year)], city = "Los Angeles")
)

# order data by city and year for following diff calculation
q6 <- q6[ order(city, year), ]
# calculate the percentage diff of each value with its previous value (for each city)
q6[city=="Baltimore", "diff"] <- Delt(q6[city=="Baltimore", sum])
q6[city=="Los Angeles", "diff"] <- Delt(q6[city=="Los Angeles", sum])
# set NA values to 0
q6[is.na(diff), ]$diff <- 0

png(file="plot6.png", width = 680, height=480) ## open png-file
options(scipen=999)   ### remove scientific notation in printing

plot <- ggplot(q6, aes(factor(year), y=diff, fill=city))
plot <- plot + geom_bar(position="dodge", stat="identity")
plot <- plot + xlab("year") + ylab("relative Rate of change")
plot <- plot + labs(title = "Comparison: Relative emission changes in Baltimore and Los Angeles")
plot <- plot + theme(plot.title = element_text(size=rel(1.5)))
print(plot)

dev.off()
