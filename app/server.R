library(shiny)
library(maps)
library("leaflet")

shinyServer(function(input, output) {
  map = leaflet() %>% 
  addTiles() %>%
  setView(lng = 360-95, lat =37, zoom = 4)
  output$mymap = renderLeaflet(map)
})
