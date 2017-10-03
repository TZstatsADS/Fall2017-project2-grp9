library(shiny)
library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(leaflet)
library(maps)
library(rgdal)

## Load housing data
load("../output/WorkData.RData")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  ## Neighborhood name
  output$text = renderText({"Selected:"})
  output$text1 = renderText({
      paste("{ ", man.nbhd[as.numeric(input$nbhd)+1], " }")
  })
  
  ## Panel 1: summary plots of time trends, 
  ##          unit price and full price of sales. 
  
  output$distPlot <- renderPlot({
    
    ## First filter data for selected neighborhood
    mh2009.sel=mh2009.use
    if(input$nbhd>0){
      mh2009.sel=mh2009.use%>%
                  filter(region %in% zip.nbhd[[as.numeric(input$nbhd)]])
    }
    
    ## Monthly counts
    month.v=as.vector(table(mh2009.sel$sale.month))
    
    ## Price: unit (per sq. ft.) and full
    type.price=data.frame(bldg.type=c("10", "13", "25", "28"))
    type.price.sel=mh2009.sel%>%
                group_by(bldg.type)%>%
                summarise(
                  price.mean=mean(sale.price, na.rm=T),
                  price.median=median(sale.price, na.rm=T),
                  unit.mean=mean(unit.price, na.rm=T),
                  unit.median=median(unit.price, na.rm=T),
                  sale.n=n()
                )
    type.price=left_join(type.price, type.price.sel, by="bldg.type")
    
    ## Making the plots
    layout(matrix(c(1,1,1,1,2,2,3,3,2,2,3,3), 3, 4, byrow=T))
    par(cex.axis=1.3, cex.lab=1.5, 
        font.axis=2, font.lab=2, col.axis="dark gray", bty="n")
    
    ### Sales monthly counts
    plot(1:12, month.v, xlab="Months", ylab="Total sales", 
         type="b", pch=21, col="black", bg="red", 
         cex=2, lwd=2, ylim=c(0, max(month.v,na.rm=T)*1.05))
    
    ### Price per square foot
    plot(c(0, max(type.price[,c(4,5)], na.rm=T)), 
         c(0,5), 
         xlab="Price per square foot", ylab="", 
         bty="l", type="n")
    text(rep(0, 4), 1:4+0.5, paste(c("coops", "condos", "luxury hotels", "comm. condos"), 
                                  type.price$sale.n, sep=": "), adj=0, cex=1.5)
    points(type.price$unit.mean, 1:nrow(type.price), pch=16, col=2, cex=2)
    points(type.price$unit.median, 1:nrow(type.price),  pch=16, col=4, cex=2)
    segments(type.price$unit.mean, 1:nrow(type.price), 
              type.price$unit.median, 1:nrow(type.price),
             lwd=2)    
    
    ### full price
    plot(c(0, max(type.price[,-1], na.rm=T)), 
         c(0,5), 
         xlab="Sales Price", ylab="", 
         bty="l", type="n")
    text(rep(0, 4), 1:4+0.5, paste(c("coops", "condos", "luxury hotels", "comm. condos"), 
                                   type.price$sale.n, sep=": "), adj=0, cex=1.5)
    points(type.price$price.mean, 1:nrow(type.price), pch=16, col=2, cex=2)
    points(type.price$price.median, 1:nrow(type.price),  pch=16, col=4, cex=2)
    segments(type.price$price.mean, 1:nrow(type.price), 
             type.price$price.median, 1:nrow(type.price),
             lwd=2)    
  })
  
  ## Panel 2: map of sales distribution
  output$distPlot1 <- renderPlot({
    count.df.sel=count.df
    if(input$nbhd>0){
      count.df.sel=count.df%>%
        filter(region %in% zip.nbhd[[as.numeric(input$nbhd)]])
    }
    # make the map for selected neighhoods
    
    zip_choropleth(count.df.sel,
                   title       = "2009 Manhattan housing sales",
                   legend      = "Number of sales",
                   county_zoom = 36061)
  })
  
  ## Panel 3: leaflet
  output$map <- renderLeaflet({
    count.df.sel=count.df
    if(input$nbhd>0){
      count.df.sel=count.df%>%
        filter(region %in% zip.nbhd[[as.numeric(input$nbhd)]])
    }
    
    # From https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u/data
    NYCzipcodes <- readOGR("../data/ZIP_CODE_040114.shp",
                           #layer = "ZIP_CODE", 
                           verbose = FALSE)
    
    selZip <- subset(NYCzipcodes, NYCzipcodes$ZIPCODE %in% count.df.sel$region)
    
    # ----- Transform to EPSG 4326 - WGS84 (required)
    subdat<-spTransform(selZip, CRS("+init=epsg:4326"))
    
    # ----- save the data slot
    subdat_data=subdat@data[,c("ZIPCODE", "POPULATION")]
    subdat.rownames=rownames(subdat_data)
    subdat_data=
      subdat_data%>%left_join(count.df, by=c("ZIPCODE" = "region"))
    rownames(subdat_data)=subdat.rownames
    
    # ----- to write to geojson we need a SpatialPolygonsDataFrame
    subdat<-SpatialPolygonsDataFrame(subdat, data=subdat_data)
    
    # ----- set uo color pallette https://rstudio.github.io/leaflet/colors.html
    # Create a continuous palette function
    pal <- colorNumeric(
      palette = "Blues",
      domain = subdat$POPULATION
    )
    
    leaflet(subdat) %>%
      addTiles()%>%
      addPolygons(
        stroke = T, weight=1,
        fillOpacity = 0.6,
        color = ~pal(POPULATION)
      )
  })
})