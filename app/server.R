library(shiny)
library(maps)
library(leaflet)
library(DT)
library(dplyr)
library(plotly)
library(ggplot2)

load("../output/workdata.Rdata")

shinyServer(function(input, output) {
  
  map = leaflet() %>% 
  addTiles() %>%
  setView(lng = 360-95, lat =40, zoom = 4)
  output$mymap = renderLeaflet(map)
  #Filter Data ----------------------------------------------------------------------------------------
  major<-reactive({
    major<-input$major
  })
  
  stp<-reactive({
    stp<-input$schtype
  })
  
  ct<-reactive({
    ct<-input$city
  })
  
  hd<-reactive({
    hd<-input$hdeg
  })
  
  st<-reactive({
    st<-input$location
  })
 
   cost<-reactive({
    cost<-input$cost
  })
   sat<-reactive({
     sat<-input$sat
   })
   act<-reactive({
     act<-input$act
   })
   
   
  d6<-reactive({
    d6<- filter(work.data, as.numeric(COSTT4_A)>=cost()[1] & as.numeric(COSTT4_A)<=cost()[2])
  } )

  d7<-reactive({
    d7<-filter(d6(), as.numeric(SAT_AVG)<sat())

  })

  d8<-reactive({
    d8<-filter(d7(), as.numeric(ACTCMMID)<act())
    })


  d1<-reactive({
    if (major() == "-----") {
      d1 <- d8()
    } 
    else {
      d1 <- d8()[d8()[,major()]==1,]
    }}) 
  
  d2<- reactive({
    if (stp() == "-----") {
      d2<-d1() 
    }  
    else {
      d2<- filter(d1(), CONTROL==stp())
    }}) 
  
  d3<- reactive({
    if (ct() == "-----") {
      d3<-d2() 
    }  
    else {
      d3<- filter(d2(), LOCALE==ct())
    }}) 
  
  d4<- reactive({
    if (hd() == "-----") {
      d4<-d3() 
    }  
    else {
      d4<- filter(d3(), HIGHDEG==hd())
    }}) 
  
  d5<- reactive({
    if (st() == "-----") {
      d5<-d4() 
    }  
    else {
      d5<- filter(d4(), STABBR==st())
    }}) 

   
   # leaflet(data =d5())%>%
   #   addTiles()%>%
   #   addMarkers(~long, ~lat)

  output$mymap <- renderLeaflet({
    urls <- paste0(as.character("<b><a href='http://"), as.character(d5()$INSTURL), "'>", as.character(d5()$INSTNM),as.character("</a></b>"))
    content <- paste(sep = "<br/>",
                     urls, 
                     paste("Rank:", as.character(d5()$Rank))
    )
    
    s = input$universities.table_rows_selected
    
    greenLeafIcon <- makeIcon(
      iconUrl = "http://www.myiconfinder.com/uploads/iconsets/256-256-f900504cdc9f243b1c6852985c35a7f7.png",
      iconWidth = 50, iconHeight = 40,
      iconAnchorX = 40, iconAnchorY = 20
    )
    
    if(length(s)){
      mapStates = map("state", fill = TRUE, plot = FALSE)
      leaflet(data = mapStates) %>% addTiles() %>%
        addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE) %>%
        addMarkers(as.numeric(d5()$LONGITUDE[-s]), as.numeric(d5()$LATITUDE[-s]), 
                   popup = content) %>%
        addMarkers(as.numeric(d5()$LONGITUDE[s]), as.numeric(d5()$LATITUDE[s]), icon = greenLeafIcon)
      
    }
    
    else{
      mapStates = map("state", fill = TRUE, plot = FALSE)
      leaflet(data = mapStates) %>% addTiles() %>%
        addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE) %>%
        addMarkers(as.numeric(d5()$LONGITUDE), as.numeric(d5()$LATITUDE), 
                 popup = content)
    }

  } )

  
  
  #Table with University List --------------------------------------------------------------------------
  
  #Filtered data frame
  
  #Table output
  output$universities.table = DT::renderDataTable({
    work.data.table <- subset(d5(), select = c("Rank", "INSTNM", "STABBR", "ADM_RATE", "ACTCMMID", "SAT_AVG","TUITIONFEE_IN", "TUITIONFEE_OUT"))
  
    colnames(work.data.table) <- c("Forbes Rank", "Institution", "State", "Admission Rate", "ACT Mid Point","Average SAT (admitted students)", "Tuition (In-State)", "Tuition (Out of State)")

    datatable(work.data.table, 
              rownames = F, selection = "single",
              options = list(order = list(list(0, 'asc'), list(1, "asc"))))  %>%
      formatPercentage(c("Admission Rate"), digits = 0) %>%
      formatCurrency(c("Tuition (In-State)", "Tuition (Out of State)"), digits = 0)
    }, server = T
  )

  #Introduction-------------------------------------------------------------------------------------------
  
  output$introduction<- renderText({
    "This is an application for perspective students to choose the colleges that fit them best. This is an Rshiny project developed by Peilin, Qihang, 
          Henrique, Kelly and Sijian. You can input your scores, expected expense, majors and some other preferences and see our recommendations for you 
          immediately. You can also see the detailed informationby clicking the marker on the interactive map. "})
  output$instruction = renderText({"the instruction goes here"})
  output$datasource = renderText({"Data source: Higher Education Datasets, 
          https://inventory.data.gov/dataset/032e19b4-5a90-41dc-83ff-6e4cd234f565/resource/38625c3d-5388-4c16-a30f-d105432553a4"
  })

  
  #Introduction-------------------------------------------------------------------------------------------
  
  output$introduction<- renderText({
          "This is an application for perspective students to choose the colleges that fit them best. This is an Rshiny project developed by Peilin, Qihang, 
          Henrique, Kelly and Sijian. You can input your scores, expected expense, majors and some other preferences and see our recommendations for you 
          immediately. You can also see the detailed informationby clicking the marker on the interactive map. "})
  output$instruction = renderText({"the instruction goes here"})
  output$datasource = renderText({"Data source: Higher Education Datasets, 
          https://inventory.data.gov/dataset/032e19b4-5a90-41dc-83ff-6e4cd234f565/resource/38625c3d-5388-4c16-a30f-d105432553a4"
  })
  #Selected indices--------------------------------------------------------------------------------------
  
  output$table.summary = renderTable({
    #s = input$universities.table_rows_selected
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      
      sub <- d5()[s,]
      
      Features <- c("Name","Website", "City", "Highest Degree", "Control")
      
      Info <- c(sub$INSTNM ,sub$INSTURL, sub$CITY, sub$HIGHDEG, sub$CONTROL)
      
      my.summary <- data.frame(cbind(Features, Info))
      my.summary
      
      } else print("Please, select a University from the table below.")
    })
  
  #------------------------------------------------------------------------------------------------------
  
  #Graphical Analysis

   output$ADM <- renderPlotly({
     s = input$universities.table_row_last_clicked
     if (length(s)) {
     university <- d5()$INSTNM[s]
     edu <- filter(fulldata, INSTNM == university)
     edu$ADM_RATE = as.numeric(edu$ADM_RATE)
     edu$Year = as.numeric(edu$Year)
     p <- ggplot(data = edu,aes(x=Year, y=ADM_RATE)) + geom_point() + geom_smooth(method = lm, color = "black") + ggtitle("5-Year Admission Rate with Trending")
     ggplotly(p)
     }
     else print("Please, select a University from the table below.")
   })
  
  output$SAT <- renderPlotly({
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      university <- d5()$INSTNM[s]
      edu <- filter(fulldata, INSTNM == university)
      edu$SAT_AVG = as.numeric(edu$SAT_AVG)
      edu$Year = as.numeric(edu$Year)
      b <- ggplot(data = edu,aes(x=Year, y=SAT_AVG)) + geom_point() + geom_smooth(method = lm, color = "black") + ggtitle("5-Year Average SAT with Trending")
      ggplotly(b)
    }
    else print("Please, select a University from the table below.")
  })
  

  output$ACT <- renderPlotly({
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      university <- d5()$INSTNM[s]
      edu <- filter(fulldata, INSTNM == university)
      edu$ACTCMMID = as.numeric(edu$ACTCMMID)
      edu$Year = as.numeric(edu$Year)
      a <- ggplot(data = edu,aes(x=Year, y=ACTCMMID)) + geom_point() + geom_smooth(method = lm, color = "black") + ggtitle("5-Year ACT MID with Trending")
      ggplotly(a)
    }
    else print("Please, select a University from the table below.")
  })
  
  output$FEM <- renderPlotly({
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      university <- d5()$INSTNM[s]
      edu <- filter(fulldata, INSTNM == university)
      edu$UGDS_WOMEN = as.numeric(edu$UGDS_WOMEN)
      edu$Year = as.numeric(edu$Year)
      d <- ggplot(data = edu,aes(x=Year, y=UGDS_WOMEN)) + geom_point() + geom_smooth(method = lm, color = "black") + ggtitle("5-Year Share of Female Undergrads with Trending")
      ggplotly(d)
    }
    else print("Please, select a University from the table below.")
  })
  
  # output$ENR <- renderPlotly({
  #   s = input$universities.table_row_last_clicked
  #   if (length(s)) {
  #     university <- d5()$INSTNM[s]
  #     edu <- filter(fulldata, INSTNM == university)
  #     edu$UGDS = as.numeric(edu$UGDS)
  #     edu$Year = as.numeric(edu$Year)
  #     e <- ggplot(data = edu,aes(x=Year, y=UGDS)) + geom_point() + geom_smooth(method = lm, color = "black") + ggtitle("5-Year Enrollments with Trending")
  #     ggplotly(e)
  #   }
  #   else print("Please, select a University from the table below.")
  # })
  # 
  


  #------------------------------------------------------------------------------------------------------
  

  })
