library(dplyr)
library(stringr)

flood <- read.csv("GlobalFloodsRecord.csv", header = T)
#colnames(flood)
nameuse <- c("Country", "Detailed.Locations..click.on.active.links.to.access.inundation.extents.", "Began", "Ended", "Duration.in.Days", "Dead", "Displaced", "Main.cause", "Severity..", "Affected.sq.km", "Magnitude..M...", "Centroid.X", "Centroid.Y", "M.6", "M.4")
floodinfo <- flood[ , nameuse]
colnames(floodinfo) <- c("Country", "Detailed.Locations", "Began", "Ended", "Duration", "Dead", "Displaced", "Cause", "Severity", "Affected.sq.km", "Magnitude", "Longitude", "Latitude", "Extreme", "Large")
#str(floodinfo)

floodinfo$Longitude <- as.numeric(as.character(floodinfo$Longitude))
floodinfo$Latitude <- as.numeric(as.character(floodinfo$Latitude))
floodinfo <- na.omit(floodinfo)

# loading the required packages
library(ggplot2)
library(ggmap)
library(googleVis)

floodinfo$Latlong <- paste(floodinfo$Latitude, floodinfo$Longitude, sep = ":")

floodinfo$Began <- as.Date(as.character(floodinfo$Began), "%d-%B-%y")
floodinfo$Ended <- as.Date(as.character(floodinfo$Ended), "%d-%B-%y")

floodinfo$date <- as.numeric(floodinfo$Began)
floodinfo$M6orM4 <- rep(NA)
for (i in (1:nrow(floodinfo))) {
        if (floodinfo$Extreme[i] == 1) {
                floodinfo$M6orM4[i] <- "M6"
        }
        else {
                floodinfo$M6orM4[i] <- "M4"
        }
}

n <- nrow(floodinfo)
a <- sort(floodinfo$Began)[2:n] - sort(floodinfo$Began)[1:n-1]
                                          
