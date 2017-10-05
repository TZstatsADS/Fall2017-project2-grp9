library(shiny)
library(maps)
library(leaflet)
library(DT)

load("../output/workdata.Rdata")

shinyServer(function(input, output) {
  
  map = leaflet() %>% 
  addTiles() %>%
  setView(lng = 360-95, lat =37, zoom = 4)
  output$mymap = renderLeaflet(map)
  
  #Table with University List --------------------------------------------------------------------------
  
  #Filtered data frame
  work.data.table <- subset(work.data, select = c("Rank", "INSTNM", "STABBR", "ADM_RATE", "ACTCMMID", "SAT_AVG",
                                                  "TUITIONFEE_IN", "TUITIONFEE_OUT"))
  
  colnames(work.data.table) <- c("Forbes Rank", "Institution", "State", "Admission Rate", "ACT Mid Point",
                                 "Average SAT (admitted students)", "Tuition (In-State)", "Tuition (Out of State)")
  
  #Table output
  output$universities.table = DT::renderDataTable({
    datatable(work.data.table, 
              rownames = F, 
              options = list(order = list(list(0, 'asc'), list(1, "asc"))))  %>%
      formatPercentage(c("Admission Rate"), digits = 0) %>%
      formatCurrency(c("Tuition (In-State)", "Tuition (Out of State)"), digits = 0)
    }, server = T
  )
  
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
