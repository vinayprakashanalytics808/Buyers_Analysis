library(shiny)
library(DT)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinydashboard)
# library(lubridate)
source("working.R")
  
  ui <- dashboardPage(
    dashboardHeader(title = "Dashboard"),
    dashboardSidebar(sidebarMenu(id="tabs",
                                 menuItem("Buyers", tabName = "raw_data")
                                 # ,menuItem("Data Set Review", tabName = "data_set_review")
    )),
    dashboardBody(tabItems(
      tabItem(tabName = "raw_data",
              htmlOutput("text1"),
              # ,h4("Buyers in 2021"),
              htmlOutput("text"),
              # tags$h4("Report Untill : WK4",style = "text-align: center;"),
              fluidRow(
                valueBoxOutput("ibox"),
                valueBoxOutput("ibox1"),
                valueBoxOutput("vbox")
                
              ),
              
              fluidRow(plotlyOutput("table")),br(),
              fluidRow(dataTableOutput("table1"))
              ))
      
    )
  )
  
  server <- function(input, output) {
    
    values_to_display <- reactiveValues()
    

    
    latest_date <- max(buyer_data$WEEK_END_DT)
    
    latest_week <- buyer_data$week[buyer_data$WEEK_END_DT == latest_date]
    latest_week_buyer <- buyer_data$ACTIVE_365D_BYRS[buyer_data$WEEK_END_DT == latest_date]
    latest_week_goal <- buyer_data$ACTIVE_365D_GOAL[buyer_data$WEEK_END_DT == latest_date]
    lastest_year <- buyer_data$year[buyer_data$WEEK_END_DT == latest_date]
    
    output$text1 <- renderUI({
      tags$h4(paste0("Buyers in : ",lastest_year))
    })
   
      
    output$text <- renderUI({
      tags$h4(paste0("Report Until : ",latest_week),style = "text-align: center;")
    })

    output$ibox <- renderValueBox({
      
      valueBox(
        h5("Total Buyers:",tags$b(format(round(latest_week_buyer,0),
                                         big.mark=",",scientific=FALSE))),
        input$count
        # icon = icon("credit-card")
      )
    })
    output$ibox1 <- renderValueBox({
      # values_to_display$ACTIVE_365D_GOAL <- values_to_display$ACTIVE_365D_GOAL - 10
      valueBox(
        h5("Addtional Buyers:",tags$b(format(round(latest_week_goal,0),
                                             big.mark=",",scientific=FALSE))),
        input$count
        # icon = icon("credit-card")
      )
    })
    
 
    output$vbox <- renderValueBox({
      valueBox(
        h5("Difference against Goal:", tags$b(
          format((latest_week_goal - latest_week_buyer),big.mark=",",scientific=FALSE))),
        input$count
        # icon = icon("credit-card")
      )
    })
    
    
    
    output$table <- renderPlotly({
      buyer_date_sum <- buyer_data %>% group_by(WEEK_ID) %>% summarise(Total_Buyers = sum(ACTIVE_365D_BYRS),
                                                                    Active_Goals = sum(ACTIVE_365D_GOAL))

      plot_ly(buyer_date_sum) %>% 
        layout(yaxis = list(title = FALSE)) %>%
        add_trace(x = ~WEEK_ID, y = ~Total_Buyers, type='scatter', mode = "lines", yaxis = "y1", line = list(color = 'red'),name = 'Total_Buyers') %>%
        add_trace(x = ~WEEK_ID, y = ~Active_Goals, type='scatter', mode = "lines", yaxis = "y1", line = list(color = 'black'), name = 'Active_Goals')
    })
    
    output$table1 <- renderDataTable({
      datatable(active_buyer_years, rownames = F,class = "compact nowrap hover row-border",
                caption = htmltools::tags$caption( style = 'caption-side: top; text-align: center; 
                                                   color:black; font-size:150% ;','Active Goals Vs Active Buyers') ) %>% formatCurrency(
        c(2,3),
        currency = "",
        interval = 3,
        mark = ",",
        digits = 2,
        dec.mark = getOption("OutDec"),
        before = TRUE
      )
      
    })

  }
  
  shinyApp(ui, server)
