# Show number of people displaced by floods over the globe. Compare every 10 years, starting 1985
# Compare the regions with the most displaced

 library(rworldmap)
 install.packages("RColorBrewer")
 library(RColorBrewer)

# Used python code 'Flood file.py" to create subset data for year of interest. Subset data generated separately and saved as "country_flood_severity_displaced_year**.csv"
# Years of interest - 85, 95, 05, 15

 f85 <- read.csv("country_flood_severity_displaced_year85.csv")
 sPDF <- joinCountryData2Map(f85, joinCode = "NAME", nameJoinColumn = "Country")
 colourPalette <- brewer.pal(4,'GnBu')
 mapCountryData( sPDF, nameColumnToPlot="Displaced", colourPalette = colourPalette, catMethod = c(0,5e+05,10e+05,15e+05,20e+05))
 mapParams <- mapCountryData(sPDF, nameColumnToPlot="Displaced", colourPalette=colourPalette, catMethod=c(0,0.5e+06,1e+06,1.5e+06,2e+06), addLegend=FALSE, mapTitle = "Displaced by floods in 1985")
 do.call( addMapLegend, c( mapParams, legendLabels="all", legendWidth=0.5))
