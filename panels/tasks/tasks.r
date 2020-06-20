  library(lcars) 
  library(ggplot2)

#This wrapper is required until shiny v1.5 is released.
moduleServer <- function(id, module) {
  callModule(module, id)
}


#I think this would be nice as a sweep.


taskpanelUI <- function(id) {
  use_waiter() # include dependencies
  waiter_show_on_load()
  uiOutput(NS(id, "panel"))
}

taskpanel <- function(id) {
  moduleServer(id, function(input, output, session) {
    library(waiter)
    

    home <- lcarsButton(
      "Home",
      "Home",
      icon = NULL,
      color = "neon-carrot",
      hover_color = "mariner",
      width = 150
    ) 
    
    
   output$panel <- renderLcarsBox(
     lcarsBox(
       fluidRow(
         column(12,includeMarkdown("panels/tasks/tasks.rmd") )
         
         
       ),
       title = "Outstanding Development Tasks",
       subtitle = "Project Status",
       corners = c(1,4), 
       sides = c(1,3,4),
       left_inputs = home,
       right_inputs = NULL,
       color = "neon-carrot",
       side_color = "neon-carrot",
       title_color = "mariner",
       subtitle_color = "mariner",
       title_right = TRUE,
       subtitle_right = TRUE,
       clip = FALSE,
       width_left = 150,
       width_right = 60
     )
     
   
   )
  })
}



panelApp <- function() {
  ui <- lcarsPage(
    taskpanelUI("lp1")
  )
  server <- function(input, output, session) {
    taskpanel("lp1")
  }
  shinyApp(ui, server)  
}


panelApp()