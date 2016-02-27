library(shiny)
library(leaflet)
library(DT)


Severity <- c(
        "All" = "", "M6" = "M6", "M4" = "M4"
)

shinyUI(navbarPage("Flood", id="nav",
                   
                   tabPanel("Dynamic Map",
                            div(class="outer",
                                
                                tags$head(
                                        # Include our custom CSS
                                        includeCSS("styles.css"),
                                        includeScript("gomap.js")
                                ),
                                
                                leafletOutput("map2", width="100%", height="100%"),
                                
                                # Shiny versions prior to 0.11 should use class="modal" instead.
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto",
                                              
                                              h2("Flood records"),
                                              
                                              radioButtons("severity", "Show Just One severity type", Severity, selected = ""),
                                              
                                              # Simple integer interval
                                              sliderInput("time", "Began date", 
                                                          min = min(floodinfo$Began), max = max(floodinfo$Began), value = min(floodinfo$Began), step = a,
                                                          animate=animationOptions(interval = 50)),
                                              helpText("Click to see dynamic flood records")
                                )
                            )
                   ),
                   
                   conditionalPanel("false", icon("crosshair"))
))