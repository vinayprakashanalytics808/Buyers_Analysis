library(shiny)
library(DT)

ui <- fluidPage(tags$head(tags$meta("df")),
  dataTableOutput("table"),
  actionButton("button","Press"),
  dataTableOutput("table1")
  
)

server <- function(input, output, session) {
  
  values_to_display <- reactiveValues()
  # mydata <- data.frame()
  output$table <- renderDataTable({
    values_to_display$mydata <- iris
    datatable(values_to_display$mydata)
  })
  
  
  observeEvent(input$button,{
    output$table1 <- renderDataTable({
      # assign("a", "new", envir = .GlobalEnv)
      values_to_display$new_data <- values_to_display$mydata[c(1,2)]
      datatable(values_to_display$new_data)
      
    })
  })
  
  observe({
    print(head(values_to_display$new_data))
  })
  
  
  
  
}

shinyApp(ui, server)