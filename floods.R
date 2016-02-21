library(RColorBrewer) 
library(lubridate)
library(animation)
library(dplyr)
library(ggmap)

################
## DATA CLEAN ##
################

## Read floods.
floods <- read.csv("GlobalFloodsRecord.csv", stringsAsFactors = F)

## Clean and generate new columns.
floods$lon <- as.numeric(floods$Centroid.X)
floods$lat <- as.numeric(floods$Centroid.Y)
floods$dead <- as.numeric(floods$Dead)
floods$displaced <- as.numeric(floods$Displaced)
floods$severity <- as.numeric(floods$Severity..)
floods$damage <- as.numeric(floods$Damage..USD.)
floods$country <- as.factor(floods$Main.cause)
floods$other <- as.factor(floods$Country)
floods$cause <- as.factor(floods$Other)
floods$magnitude <- as.numeric(floods$Magnitude..M...)
floods$began <- as.Date(floods$Began,"%d-%b-%y")
floods$ended <- as.Date(floods$Ended,"%d-%b-%y")
floods$start <- year(floods$began)
floods$end <- year(floods$ended)

## Remove useless columns.
floods2 <- tbl_df(floods[,-(1:30)])
#floods2 <- floods2[complete.cases(floods2),]
head(floods2)

## Range of years.
r <- range(floods2$start, na.rm=T)

#################
## EXPLORATORY ##
#################

## Make movie of floods in America.
map <- get_map(location = "America", zoom = 3)

saveGIF({
  for(i in seq(r[1], r[2])) {
    print(ggmap(map, legend = "none") +
      geom_point(data = floods2[floods2$start == i,], aes(lon, lat,  size = dead, colour = severity), alpha = 0.7)
    )
  }
}, interval = 0.2, movie.name = "floods.gif", ani.width = 600, ani.height = 600)