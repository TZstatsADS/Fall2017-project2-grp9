library(shiny)
library(maps)
library(leaflet)
library(DT)



shinyUI(fluidPage(
  
  
  # Application title
  titlePanel("Choose a college for you"),
  
  sidebarPanel(
  
    selectInput("sat", "SAT score", choices = c("lower than 1600","1600-1800","1800-2000","2000-2200","2200-2400")),
  
    selectInput("act", "ACT score", choices = c("lower than 20","20-25","25-30","30-33","33-36")),
  
    selectInput("gpa", "high school GPA", choices = c("lower than 2","2-2.5","2.5-3","3-3.5","3.5-3.8","3.8-4")),
  
    selectInput("location"," Where you want to take your college in?",
              choices = c("Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida"
              ,"Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland"
              ,"Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire"
              ,"New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania"
              ,"Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington"
              ,"West Virginia","Wisconsin","Wyoming","District of Columbia","Puerto Rico","Guam"," American Samoa"
              ,"U.S. Virgin Islands","Northern Mariana Islands")),
  width = 4),
  
  mainPanel(
  
    leafletOutput("mymap")
  ),
  
  wellPanel(
  
    DT::dataTableOutput("universities.table")
  
    ),
  
  fluidRow(

    column(4, verbatimTextOutput('example'))
  )
  
))
