
#Set-up
library(shiny)
library(leaflet)

state.list <- c("AL", "IL", "AK", "AZ", "NM", "AR", "CA", "MN", "CO", "CT", "NY",
"DE", "DC", "VA", "FL", "GA", "HI", "ID", "IN", "TN", "MI", "IA",
"KS", "MO", "KY", "LA", "ME", "MD", "MA", "MS", "MT", "NE", "NV",
"NH", "NJ", "NC", "ND", "OH", "WV", "OK", "OR", "PA", "RI", "SC",
"SD", "TX", "UT", "VT", "WA", "WI", "WY", "AS", "GU", "MP", "PR",
"FM", "PW", "VI", "MH")

state.list <- state.list[order(state.list)]


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("College Scorecard: Where do I want to study?"),
  
  # Sidebar with a selector input for neighborhood
  sidebarLayout(
    sidebarPanel(
      selectInput("state", label = h5("Choose a State"), 
                         choices = state.list, 
                         selected = 0)
    ),
    # Show two panels
    mainPanel(
      #h4(textOutput("text")),
      h3(code(textOutput("text1"))),
      tabsetPanel(
        # Panel 1 has three summary plots of sales. 
        tabPanel("Sales summary", plotOutput("distPlot")), 
        # Panel 2 has a map display of sales' distribution
        tabPanel("Sales map", plotOutput("distPlot1"))),
      leafletOutput("map", width = "80%", height = "400px")
    )
 )
))

