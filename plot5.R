## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### libraries
library(data.table)
library(ggplot2)

# merge SCC to NEI data by Sector-Number
data <- merge( data.table(NEI), data.table(SCC), by = "SCC", all=TRUE)
# motor vehicles or road-vehicle, therefore no Non-Road, Locomotive, Airplane or marine vessels
q5 <- data[grep("^mobile - on-road", data$EI.Sector, ignore.case=TRUE), ]
q5 <- rbind(
   q5[fips=="24510", list(sum=sum(Emissions)), by=list(year, EI.Sector)],
   q5[fips=="24510", list(EI.Sector="Combined", sum=sum(Emissions)), by=list(year)]
)
q5 <- q5[ (!is.na(sum)), ]

png(file="plot5.png", width = 680, height=480) ## open png-file
par(family="serif")   ### set font-family
options(scipen=999)   ### remove scientific notation in printing
qplot(year, sum, data = q5, colour = EI.Sector, geom="line", main="Total Emissions in Baltimore by motor vehicles \n and combined") + ylab("Sum") + xlab("Year") + geom_smooth(linetype=5, method="lm", se=F)
dev.off()
