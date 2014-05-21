## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### libraries
library(data.table)


# to data.table
data <- data.table(NEI)

# group and filter data
q2 <- data[ fips=="24510", list(sum=sum(Emissions)), by=year]

png(file="plot2.png", width = 480, height=480) ## open png-file
par(family="serif")   ### set font-family
options(scipen=999)   ### remove scientific notation in printing
plot(q2$year, q2$sum, type='l', xlab="Year", ylab="Sum", main="Total Emissions") ### plot the data
dev.off() ### write file to disc

