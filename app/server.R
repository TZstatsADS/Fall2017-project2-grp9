library(shiny)
library(maps)
library(leaflet)
library(DT)
library(dplyr)

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
      d1 <- d8[d8[,major()]==1,]
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
 
  #Table with University List --------------------------------------------------------------------------
  
  #Filtered data frame
  
  #Table output
  output$universities.table = DT::renderDataTable({
    work.data.table <- subset(d5(), select = c("Rank", "INSTNM", "STABBR", "ADM_RATE", "ACTCMMID", "SAT_AVG","TUITIONFEE_IN", "TUITIONFEE_OUT"))
  
    colnames(work.data.table) <- c("Forbes Rank", "Institution", "State", "Admission Rate", "ACT Mid Point","Average SAT (admitted students)", "Tuition (In-State)", "Tuition (Out of State)")

    datatable(work.data.table, 
              rownames = F, 
              options = list(order = list(list(0, 'asc'), list(1, "asc"))))  %>%
      formatPercentage(c("Admission Rate"), digits = 0) %>%
      formatCurrency(c("Tuition (In-State)", "Tuition (Out of State)"), digits = 0)
    }, server = T
  )
  output$introduction<- renderText({"This is an application for perspective students to choose the colleges that fit them best, developed by u u u and me"})
  
  #Selected indices--------------------------------------------------------------------------------------
  
  output$example = renderPrint({
    s = input$universities.table_rows_selected
    if (length(s)) {
      cat('These rows were selected:\n\n')
      cat(s, sep = ', ')
      }
    })
  
  #------------------------------------------------------------------------------------------------------
  

  })
