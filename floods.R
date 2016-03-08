require(lubridate)
library(animation)
library(reshape2)
library(dplyr)

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


## Remove useless columns and add grouping dates.
floods2 <- tbl_df(floods[,-(1:30)])
floods2 <- floods2[!is.na(floods2$began),]
breaks = round(seq(1985, 2016, 7.75))
floods2$breaks <- cut(floods2$start, breaks = breaks, labels = breaks[-1], right = F)
head(floods2)

#################
## EXPLORATORY ##
#################

## Make movie of floods in America.
# map <- get_map(location = "America", zoom = 3)
# 
# ## Range of years.
# r <- range(floods2$start, na.rm=T)
# 
# saveGIF({
#   for(i in seq(r[1], r[2])) {
#     print(ggmap(map, legend = "none") +
#       geom_point(data = floods2[floods2$start == i,], aes(lon, lat,  size = dead, colour = severity), alpha = 0.7)
#     )
#   }
# }, interval = 0.2, movie.name = "floods.gif", ani.width = 600, ani.height = 600)


## Plot floods by continent.
require(ggplot2)
require(ggmap)
require(RColorBrewer)

flood.cols <- brewer.pal(n = 5, name = "OrRd")

## NORTH AMERICA
america <- get_map("America", zoom =4 , maptype = "roadmap")

america.map <- ggmap(america,  extent="panel") %+%
  floods2 +
  #aes(x = lon, y = lat, z = log(displaced)) +
  aes(x = lon, y = lat) +
  #stat_summary_2d(fun = "sum", bins = 60, alpha = 0.75) + 
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon") +
  scale_fill_gradientn(name = "Floods", colours = flood.cols, space = "Lab") +
  scale_alpha(range = c(0.1, 0.5)) +
  labs(x = "Longitude", y = "Latitude", title = "North America") +
  theme(legend.position = "none") +
  coord_map()

america.facet <- america.map +
  geom_point(aes(x = lon, y = lat, size = displaced), fill="red", shape=21, alpha=0.8) +
  facet_wrap(~ breaks)

america.facet

## SOUTH AMERICA
south.america <- get_map("South America", zoom =4 , maptype = "roadmap")

south.america.map <- ggmap(south.america,  extent="panel") %+%
  floods2 +
  #aes(x = lon, y = lat, z = log(displaced)) +
  aes(x = lon, y = lat) +
  #stat_summary_2d(fun = "sum", bins = 60, alpha = 0.75) + 
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon") +
  scale_fill_gradientn(name = "Floods", colours = flood.cols, space = "Lab") +
  scale_alpha(range = c(0.1, 0.5)) +
  labs(x = "Longitude", y = "Latitude", title = "South America") +
  theme(legend.position = "none") +
  coord_map()

south.america.facet <- south.america.map +
  geom_point(aes(x = lon, y = lat, size = displaced), fill="red", shape=21, alpha=0.8) +
  facet_wrap(~ breaks)

south.america.facet

## EUROPE
europe <- get_map("Europe", zoom =4 , maptype = "roadmap")

europe.map <- ggmap(europe,  extent="panel") %+%
  floods2 +
  #aes(x = lon, y = lat, z = log(displaced)) +
  aes(x = lon, y = lat) +
  #stat_summary_2d(fun = "sum", bins = 60, alpha = 0.75) + 
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon") +
  scale_fill_gradientn(name = "Floods", colours = flood.cols, space = "Lab") +
  scale_alpha(range = c(0.1, 0.5)) +
  labs(x = "Longitude", y = "Latitude", title = "Europe") +
  theme(legend.position = "none") +
  coord_map()

europe.facet <- europe.map +
  geom_point(aes(x = lon, y = lat, size = displaced), fill="red", shape=21, alpha=0.8) +
  facet_wrap(~ breaks)

europe.facet

## ASIA
asia <- get_map("Asia", zoom =4 , maptype = "roadmap")

asia.map <- ggmap(asia,  extent="panel") %+%
  floods2 +
  #aes(x = lon, y = lat, z = log(displaced)) +
  aes(x = lon, y = lat) +
  #stat_summary_2d(fun = "sum", bins = 60, alpha = 0.75) + 
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon") +
  scale_fill_gradientn(name = "Floods", colours = flood.cols, space = "Lab") +
  scale_alpha(range = c(0.1, 0.5)) +
  labs(x = "Longitude", y = "Latitude", title = "Asia") +
  theme(legend.position = "none") +
  coord_map()

asia.facet <- asia.map +
  geom_point(aes(x = lon, y = lat, size = displaced), fill="red", shape=21, alpha=0.8) +
  facet_wrap(~ breaks)

asia.facet

## AFRICA
africa <- get_map("Africa", zoom =4 , maptype = "roadmap")

africa.map <- ggmap(africa,  extent="panel") %+%
  floods2 +
  #aes(x = lon, y = lat, z = log(displaced)) +
  aes(x = lon, y = lat) +
  #stat_summary_2d(fun = "sum", bins = 60, alpha = 0.75) + 
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon") +
  scale_fill_gradientn(name = "Floods", colours = flood.cols, space = "Lab") +
  scale_alpha(range = c(0.1, 0.5)) +
  labs(x = "Longitude", y = "Latitude", title = "Africa") +
  theme(legend.position = "none") +
  coord_map()

africa.facet <- africa.map +
  geom_point(aes(x = lon, y = lat, size = displaced), fill="red", shape=21, alpha=0.8) +
  facet_wrap(~ breaks)

africa.facet

## AUSTRALIA
australia <- get_map("Australia", zoom =4 , maptype = "roadmap")

australia.map <- ggmap(australia,  extent="panel") %+%
  floods2 +
  #aes(x = lon, y = lat, z = log(displaced)) +
  aes(x = lon, y = lat) +
  #stat_summary_2d(fun = "sum", bins = 60, alpha = 0.75) + 
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon") +
  scale_fill_gradientn(name = "Floods", colours = flood.cols, space = "Lab") +
  scale_alpha(range = c(0.1, 0.5)) +
  labs(x = "Longitude", y = "Latitude", title = "Australia") +
  theme(legend.position = "none") +
  coord_map()

australia.facet <- australia.map +
  geom_point(aes(x = lon, y = lat, size = displaced), fill="red", shape=21, alpha=0.8) +
  facet_wrap(~ breaks)

australia.facet


### GIFs
fname <- 'new_phi_data_cc.nc'
ncin <- nc_open(fname)

time <- ncvar_get(ncin, 'T')
lon <- ncvar_get(ncin,'X')
lat <- rev(ncvar_get(ncin, 'Y'))
pre <- ncvar_get(ncin, 'P')

phi.array <- ncvar_get(ncin, 'phi')

length(time)

saveGIF({
  for(i in 365:547) {
    phi.slice <- phi.array[ , , i]
    image(lon, lat, phi.slice, col = brewer.pal(10, "RdBu"))
    title(main=as.Date("1948-01-01") + i)
  }
}, movie.name = "preassure1.gif", interval = 0.1, ani.width = 400, ani.height = 200)

saveGIF({
  for(i in 12447:12629) {
    phi.slice <- phi.array[ , , i]
    image(lon, lat, phi.slice, col = brewer.pal(10, "RdBu"))
    title(main=as.Date("1948-01-01") + i)
  }
}, movie.name = "preassure2.gif", interval = 0.1, ani.width = 400, ani.height = 200)

saveGIF({
  for(i in 23617:23799) {
    phi.slice <- phi.array[ , , i]
    image(lon, lat, phi.slice, col = brewer.pal(10, "RdBu"))
    title(main=as.Date("1948-01-01") + i)
  }
}, movie.name = "preassure3.gif", interval = 0.1, ani.width = 400, ani.height = 200)

saveGIF({
  for(i in 24712:24895) {
    phi.slice <- phi.array[ , , i]
    image(lon, lat, phi.slice, col = brewer.pal(10, "RdBu"))
    title(main=as.Date("1948-01-01") + i)
  }
}, movie.name = "preassure4.gif", interval = 0.1, ani.width = 400, ani.height = 200)