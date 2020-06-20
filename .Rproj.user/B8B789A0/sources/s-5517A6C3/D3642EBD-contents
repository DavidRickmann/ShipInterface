  library(lcars) 
  library(ggplot2)
  library(shinyjs)

#This wrapper is required until shiny v1.5 is released.
moduleServer <- function(id, module) {
  callModule(module, id)
}


#write a standard nav button function
#get the colours from the theme?
#allow assignation of standard colours in the config

environmentpanelUI <- function(id) {
  
  #load sound functions

  
  uiOutput(NS(id, "panel"))
}

environmentpanel <- function(id, config) {
  moduleServer(id, function(input, output, session) {
    
    ship <- config
    key <- ship$commandkey
    
   
    useShinyjs()
    extendShinyjs(script = here("panels","beep.js"))
    
    #pump controls  
    
    observeEvent(input$button1, {
      event <- "pump_on"
      maker_url <- paste('https://maker.ifttt.com/trigger', event, 'with/key', key, sep='/')
      js$processing3()
      httr::POST(maker_url)
    }) 
    
    observeEvent(input$button2, {
      event <- "pump_off"
      maker_url <- paste('https://maker.ifttt.com/trigger', event, 'with/key', key, sep='/')
      js$processing3()
      httr::POST(maker_url)
    })
    
    
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
     title = "Environmental systems",
     subtitle = "Waste extraction",
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
     width_right = 60,
     fluidRow(
       column(4,
              includeMarkdown(here("panels","environmental","environmental.rmd")),
              fluidRow(
                column(6,
                       lcarsButton(
                         "button1",
                         "Engage",
                         icon = NULL,
                         color = "neon-carrot",
                         hover_color = "mariner",
                         width = 150
                       )
                ),
                column(6,
                       lcarsButton(
                         "button2",
                         "Disengage",
                         icon = NULL,
                         color = "neon-carrot",
                         hover_color = "mariner",
                         width = 150
                       )
                )
              )
       ),
       column(2),
       column(6,
              
              lcarsBox(
                fluidRow(img(src="/panels/environmental/res/Engine2.png", align = "center")),
                title = "schematics",
                corners = c(1,2,3,4),
                sides = NULL,
                color = "mariner",
                title_color = "mariner",
                title_right = TRUE,
                subtitle_right = TRUE,
                clip = FALSE,
                width_left = 60,
                width_right = 60
              )
       )
       
     )
     )
   )
   
  })
}



panelApp <- function() {
  ui <- lcarsPage(
    environmentpanelUI("ep1")
  )
  server <- function(input, output, session) {
    environmentpanel("ep1")
  }
  shinyApp(ui, server)  
}


panelApp()