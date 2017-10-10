packages.used=c("shiny", "plotly", "shinydashboard", "leaflet","DT")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE,repos = "http://cran.us.r-project.org")
}

library(shiny)
library(maps)
library(leaflet)
library(DT)
library(shinydashboard)
library(plotly)



dashboardPage(
  
  dashboardHeader(title='Find your university!'),
  skin = "blue",
  dashboardSidebar(
    sidebarMenu(id='sidebarmenu',
                menuItem("Introduction",tabName="overview",icon=icon("info")),
                menuItem("Choose the University",tabName="university_search",icon=icon("search"))
    ),
  
    sliderInput("cost", label = "Cost by Year ", min = 0, max =80000, value = c(1,80000)),
    sliderInput(inputId="sat",label = "SAT Score",value = 1600,min = 0,max = 1600,step = 1 ),
    sliderInput("act",label = "ACT Score",min=0,max=36, value =36,step = 1 ),
    selectInput("location"," Where you want to take your college in?",
              choices = c("-----","AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE"
              ,"FL","FM","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD"
              ,"ME","MH","MI","MN","MO","MP","MS","MT","NC","ND","NE","NH","NJ","NM","NV"
              ,"NY","OH","OK","OR"
              ,"PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT"
              ,"WA","WI","WV","WY")),
    
    selectInput("major", "Major",
                choices = c("-----",
                            "Agriculture, Agriculture Operations, and Related Sciences","Natural Resources and Conservation","Architecture and Related Services",
                            "Area, Ethnic, Cultural, Gender, and Group Studies","Communication, Journalism, and Related Programs","Communications Technologies/Technicians and Support Services",
                            "Computer and Information Sciences and Support Services","Personal and Culinary Services","Education","Engineering","Engineering Technologies and Engineering-Related Fields",
                            "Foreign Languages, Literatures, and Linguistics","Family and Consumer Sciences/Human Sciences","Legal Professions and Studies","English Language and Literature/Letters",
                            "Liberal Arts and Sciences, General Studies and Humanities","Library Science","Biological and Biomedical Sciences","Mathematics and Statistics",
                            "Military Technologies and Applied Sciences","Multi/Interdisciplinary Studies","Parks, Recreation, Leisure, and Fitness Studies","Philosophy and Religious Studies",
                            "Theology and Religious Vocations","Physical Sciences","Science Technologies/Technicians","Psychology","Homeland Security, Law Enforcement, Firefighting and Related Protective Services",
                            "Public Administration and Social Service Professions","Social Sciences","Construction Trades","Mechanic and Repair Technologies/Technicians","Precision Production",
                            "Transportation and Materials Moving","Visual and Performing Arts","Health Professions and Related Programs",
                            "Business, Management, Marketing, and Related Support Services","History")),
    
    selectInput("city", "City Size", choices = c("-----","City","Suburb","Town","Rural")),
    
    selectInput("schtype", "Control of Instituion", choices = c("-----","Public","Private nonprofit","Private for-profit")),
    
    selectInput("hdeg", "Highest Degree", choices = c("-----","Graduate","Bachelor","Associate","Certificate","Non-degree-granting")),
    
    width = '300'

    ),
    
    dashboardBody(
      
      tabItems(
        
        tabItem(tabName = "overview",
                mainPanel(
                  
                  textOutput("introduction"),
                  textOutput("instruction"),
                  textOutput("instruction1"),
                  textOutput("instruction2"),
                  textOutput("instruction3"),
                  textOutput("instruction4"),
                  textOutput("instruction5"),
                  textOutput("datasource1"),
                  textOutput("datasource2"),
                  textOutput("datasource3"),
                  textOutput("datasource4")
                  
                )),
        
        
        tabItem(tabName = "university_search",
                fluidRow(
                                   tabBox(width=12,
                         tabPanel(title="Map", width = 12, solidHeader = T, leafletOutput("mymap")),
                          
                         tabPanel(title="Detailed Summary", width = 12, solidHeader = T, 
                                     fluidRow(
                                       column(3,tableOutput("table.summary")),
                                       column(3,tableOutput("table.summary2")),
                                       column(4,tableOutput("table.summary3"))
                                       
                            
                          )),
                         tabPanel(title = "Admission Rate Trend", width = 12, solidHeader = T, plotlyOutput("ADM")),
                         tabPanel(title = "Average SAT Trend", width = 12, solidHeader = T, plotlyOutput("SAT")),
                         tabPanel(title = "MID ACT Trend", width = 12, solidHeader = T, plotlyOutput("ACT")),
                         tabPanel(title = "Share of Female Students Trend", width = 12, solidHeader = T, plotlyOutput("FEM")),
                         tabPanel(title = "Total Enrollments Trend", width = 12, solidHeader = T, plotlyOutput("ENR"))
                  ),
                  
                  
                  tabBox(width = 12,
                         
                         tabPanel('Ranking',
                                  dataTableOutput("universities.table"),
                                  tags$style(type="text/css", '#myTable tfoot {display:none;}')) 
                )
                

        
        
        
        
      )
))))