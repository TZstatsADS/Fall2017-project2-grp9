library(shiny)
library(maps)
library(leaflet)
library(DT)
library(dplyr)
library(plotly)
library(ggplot2)

load("../output/workdata.Rdata")
load("../output/fulldata.Rdata")

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
    
    url2 <- paste0(as.character("<b><a href='http://"), as.character(d5()$INSTURL[s]), "'>", as.character(d5()$INSTNM[s]),as.character("</a></b>"))
    content2 <- paste(sep = "<br/>",
                     url2, 
                     paste("Rank:", as.character(d5()$Rank[s]))
    )
    
    greenLeafIcon <- makeIcon(
      iconUrl = "../lib/RedPin.png",
      iconWidth = 64, iconHeight = 64,
      iconAnchorX = 32, iconAnchorY = 59
    )
    
    if(length(s)){
      mapStates = map("state", fill = TRUE, plot = FALSE)
      leaflet(data = mapStates) %>% addTiles() %>%
        addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE) %>%
        addMarkers(as.numeric(d5()$LONGITUDE[-s]), as.numeric(d5()$LATITUDE[-s]), 
                   popup = content) %>%
        addMarkers(as.numeric(d5()$LONGITUDE[s]), as.numeric(d5()$LATITUDE[s]),
                   icon = greenLeafIcon, popup = content2)
      
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
          Henrique, Kelly and Sijian. You can input your preferences and see our recommendations for you 
          immediately."})
  
  output$instruction = renderText({"Instruction:"})
  output$instruction1 = renderText({"1. slide the bar to choose the cost consisting of tuition and living expenses for one academic year that you would like to afford."})
  output$instruction2 = renderText({"2. slide the bar to submit your SAT scores and ACT scores. If you don't have one please slide the bar to the right."})
  output$instruction3 = renderText({"3. choose the location, major, city size, school type and highest degree you would like. If you don't have preference, please leave them as blank."})
  output$instruction4 = renderText({"4. Finishing step 1-3, the universities that fit you with infomation you may need will show on the table. By clicking each row of the table, a red pin in the map pops up to show its location.  "})
  output$instruction5 = renderText({"5. Besides, by selecting the tabs next to the tab of Map,  you can see the 10-year trending of each statistics."})
  output$datasource1 = renderText({"Data: https://catalog.data.gov/dataset/college-scorecard"})
  output$datasource2 = renderText({"Data dictionary: https://collegescorecard.ed.gov/data/documentation/"})
  output$datasource3 = renderText({"Study on Dataset: https://collegescorecard.ed.gov/assets/UsingFederalDataToMeasureAndImprovePerformance.pdf"})
  output$datasource4 = renderText({"Forbes Ranks Data: http://www.forbes.com/sites/nataliesportelli/2016/07/06/the-full-list-of-americas-top-colleges-2016/#191c50d569a4"})
  #Selected indices--------------------------------------------------------------------------------------
  
output$table.summary = renderTable({
    #s = input$universities.table_rows_selected
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      
      sub <- d5()[s,]
      
      Institution <- c("Name","Website", "City", "Highest Degree", "Control", "City Size")
      
      Info <- c(sub$INSTNM ,sub$INSTURL, sub$CITY, sub$HIGHDEG, sub$CONTROL, sub$LOCALE)
      
      my.summary <- data.frame(cbind(Institution, Info))
      my.summary
      
      } else print("Please, select a University from the table below.")
    })
  
  output$table.summary2 = renderTable({
    #s = input$universities.table_rows_selected
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      
      university <- d5()$INSTNM[s]
      sub <- filter(fulldata, INSTNM == university & Year == "2016")
      
      Demographics <- c("Male %", "Female %", "Average age of entry", "% of Undergraduates aged 25+")
      
      Info <- c(as.numeric(sub$UGDS_MEN)*100, as.numeric(sub$UGDS_WOMEN)*100, 
                round(as.numeric(sub$AGE_ENTRY), digits = 2), as.numeric(sub$UG25ABV)*100)
      
      my.summary <- data.frame(cbind(Demographics, Info))
      names(my.summary) <- c("Demographics (2016)", "Info")
      my.summary
      
    } 
  })
  
  output$table.summary3 = renderTable({
    #s = input$universities.table_rows_selected
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      
      university <- d5()$INSTNM[s]
      sub <- filter(fulldata, INSTNM == university)
      sub[sub == "NULL"] <-NA
      
      Financial <- c("Undergraduate students receiving federal loan %", "Median Debt: Students who have completed", 
                 "Median Debt: Students who have NOT completed", "Median Earnings: Students 10 years after entry")
      
      Info <- c(round(mean(as.numeric(sub$PCTFLOAN), na.rm = T) * 100,2), round(mean(as.numeric(sub$GRAD_DEBT_MDN), na.rm = T),0), 
                round(mean(as.numeric(sub$WDRAW_DEBT_MDN), na.rm = T) * 100,0), round(mean(as.numeric(sub$MD_EARN_WNE_P10), na.rm = T),0))
      
      my.summary <- data.frame(cbind(Financial, Info))
      names(my.summary) <- c("Financial (last 5 years average)", "Info")
      my.summary
      
    } 
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
     else {
       ggplotly(ggplot()+ggtitle("Please, select a University from the table below."))
     }
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
    else  {
      ggplotly(ggplot()+ggtitle("Please, select a University from the table below."))
    }
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
    else  {
      ggplotly(ggplot()+ggtitle("Please, select a University from the table below."))
    }
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
    else  {
      ggplotly(ggplot()+ggtitle("Please, select a University from the table below."))
    }
  })
  
  output$ENR <- renderPlotly({
    s = input$universities.table_row_last_clicked
    if (length(s)) {
      university <- d5()$INSTNM[s]
      edu <- filter(fulldata, INSTNM == university)
      edu$UGDS = as.numeric(edu$UGDS)
      edu$Year = as.numeric(edu$Year)
      e <- ggplot(data = edu,aes(x=Year, y=UGDS)) + geom_point() + geom_smooth(method = lm, color = "black") + ggtitle("5-Year Enrollments with Trending")
      ggplotly(e)
    }
    else {
      ggplotly(ggplot()+ggtitle("Please, select a University from the table below."))
    }
  })

  


  #------------------------------------------------------------------------------------------------------
  

  })