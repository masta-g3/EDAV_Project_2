library(shiny)
library(leaflet)
library(RColorBrewer)
library(dplyr)
library(ggplot2)


shinyServer(function(input, output, session) {
        
        
        
        ## Dynamic Map ###########################################
        
        # Create the map
        output$map2 <- renderLeaflet({
                leaflet() %>%
                        addTiles(
                                urlTemplate = "https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
                                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
                        ) 
                        #setView(lng = -73.97, lat = 40.75, zoom = 13)
        })
        
        
        # Filter crime data
        drawvalue <- reactive({
                if (input$severity == ''){
                        t <- filter(floodinfo, date == input$time)
                        return(t)
                }
                else{
                        t <- filter(floodinfo, M6orM4 == input$severity, date==input$time)
                        return(t)
                }})
        
        observe({
                draw <- drawvalue()
                pal <- colorFactor(palette()[2:3], levels(floodinfo$M6orM4))
                radius <-  1000
                if (length(as.matrix(draw)) != 0) {
                        leafletProxy("map2", data = draw) %>%
                                clearMarkers() %>%
                                #addCircles(~Longitude, ~Latitude, radius=radius,
                                #           stroke=FALSE, fillOpacity=0.8,fillColor=pal(draw[["M6orM4"]])) %>%
                                addMarkers(~Longitude, ~Latitude, icon = NULL, options = markerOptions(opacity = 0.9), popup = ~Cause) %>%
                                addLegend("bottomleft", pal=pal, values=levels(draw[["M6orM4"]]), layerId="colorLegend")
                }
                else {
                        leafletProxy("map2", data = draw) %>%
                                clearShapes()
                }
                
                
        })
        
})