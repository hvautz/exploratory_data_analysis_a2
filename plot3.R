## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### libraries
library(data.table)
library(ggplot2)


# to data.table
data <- data.table(NEI)

# group and filter data
q3 <-data[fips=="24510", list(sum=sum(Emissions)), by=list(year,type) ]

png(file="plot3.png", width = 480, height=480) ## open png-file
par(family="serif")   ### set font-family
options(scipen=999)   ### remove scientific notation in printing
qplot(year, sum, data = q3, colour = type, geom="line") + ylab("Sum") + xlab("Year") + geom_smooth(linetype=5, method="lm", se=F)
dev.off()
