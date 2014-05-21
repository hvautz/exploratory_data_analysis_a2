## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### libraries
library(data.table)
library(ggplot2)

# merge SCC to NEI data by Sector-Number
data <- merge( data.table(NEI), data.table(SCC), by = "SCC", all=TRUE)
q4 <- data[ grep("^.*comb.*coal.*$", data$EI.Sector, ignore.case=TRUE), ]
q4 <- rbind(
   q4[, list(sum=sum(Emissions)), by=list(year, EI.Sector)],
   q4[, list(EI.Sector="Combined", sum=sum(Emissions)), by=list(year)]
)
q4 <- q4[ (!is.na(sum)), ]


png(file="plot4.png", width = 680, height=480) ## open png-file
par(family="serif")   ### set font-family
options(scipen=999)   ### remove scientific notation in printing
qplot(year, sum, data = q4, colour = EI.Sector, geom="line", main="Total Emissions by coal comb. related sources \n and combined") + ylab("Sum") + xlab("Year") + geom_smooth(linetype=5, method="lm", se=F)
dev.off()
