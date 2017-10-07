library(shiny)
library(maps)
library(leaflet)
library(DT)



shinyUI(fluidPage(
  
  
  # Application title
  titlePanel("Choose a college for you"),
  
  sidebarPanel(
  
    selectInput("sat", "SAT score", choices = c("-----","lower than 1600","1600-1800","1800-2000","2000-2200","2200-2400")),
  
    selectInput("act", "ACT score", choices = c("-----","lower than 20","20-25","25-30","30-33","33-36")),
  
    selectInput("location"," Where you want to take your college in?",
              choices = c("-----","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE"
              ,"FL","FM","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD"
              ,"ME","MH","MI","MN","MO","MP","MS","MT","NC","ND","NE","NH","NJ","NM","NV"
              ,"NY","OH","OK","OR"
              ,"PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT"
              ,"WA","WI","WV","WY")),
    
    selectInput("major", "Major",
                choices = c("-----",
                            "Agriculture, Agriculture Operations, and Related Sciences",
                            "Natural Resources and Conservation",
                            "Architecture and Related Services",
                            "Area, Ethnic, Cultural, Gender, and Group Studies",
                            "Communication, Journalism, and Related Programs",
                            "Communications Technologies/Technicians and Support Services",
                            "Computer and Information Sciences and Support Services",
                            "Personal and Culinary Services",
                            "Education",
                            "Engineering",
                            "Engineering Technologies and Engineering-Related Fields",
                            "Foreign Languages, Literatures, and Linguistics",
                            "Family and Consumer Sciences/Human Sciences",
                            "Legal Professions and Studies",
                            "English Language and Literature/Letters",
                            "Liberal Arts and Sciences, General Studies and Humanities",
                            "Library Science",
                            "Biological and Biomedical Sciences",
                            "Mathematics and Statistics",
                            "Military Technologies and Applied Sciences",
                            "Multi/Interdisciplinary Studies",
                            "Parks, Recreation, Leisure, and Fitness Studies",
                            "Philosophy and Religious Studies",
                            "Theology and Religious Vocations",
                            "Physical Sciences",
                            "Science Technologies/Technicians",
                            "Psychology",
                            "Homeland Security, Law Enforcement, Firefighting and Related Protective Services",
                            "Public Administration and Social Service Professions",
                            "Social Sciences",
                            "Construction Trades",
                            "Mechanic and Repair Technologies/Technicians",
                            "Precision Production",
                            "Transportation and Materials Moving",
                            "Visual and Performing Arts",
                            "Health Professions and Related Programs",
                            "Business, Management, Marketing, and Related Support Services",
                            "History")),
    
    selectInput("city", "City Size", choices = c("-----","City","Suburb","Town","Rural")),
    
    selectInput("schtype", "Control of Instituion", choices = c("-----","Public","Private nonprofit","Private for-profit")),
    
    selectInput("hdeg", "Highest Degree", choices = c("-----","Graduate","Bachelor","Associate","Certificate","Non-degree-granting")),
    
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
