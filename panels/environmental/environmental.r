  library(lcars) 
  library(ggplot2)
  library(shinyjs)
  library(httr)

#This wrapper is required until shiny v1.5 is released.
moduleServer <- function(id, module) {
  callModule(module, id)
}


#write a standard nav button function
#get the colours from the theme?
#allow assignation of standard colours in the config

environmentpanelUI <- function(id) {
  
  #load sound functions
  useShinyjs()
  extendShinyjs(script = here("panels","beep.js"))
  
  ns <- NS(id)
  
  
  
  home <- lcarsButton(
    "Home",
    "Home",
    icon = NULL,
    color = "neon-carrot",
    hover_color = "mariner",
    width = 150
  ) 
  
  lcarsPage(
    fluidRow(
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
                          ns("button1"),
                          label = "Engage",
                          icon = NULL,
                          color = "neon-carrot",
                          hover_color = "mariner",
                          width = 150
                        )
                 ),
                 column(6,
                        lcarsButton(
                          ns("button2"),
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
                 fluidRow(
                   align="center",
                   plotOutput(ns("blueprint"))
                   ),
                 title = "schematics",
                 corners = c(1,2,3,4),
                 sides = NULL,
                 color = "mariner",
                 title_color = "mariner",
                 title_right = TRUE,
                 subtitle_right = TRUE,
                 clip = TRUE,
                 width_left = 60,
                 width_right = 60
               )
        )
        
      )
    )
  
    ))  
  
}

environmentpanel <- function(id, config) {
  moduleServer(id, function(input, output, session) {
    
    openhab <- get("openhab")
    itemname <- "HS110_Power"
    openhab_url <- paste0("http://",openhab$IP,":",openhab$Port,"/rest/items/",itemname)
    
  
    #pump controls  
    
    observeEvent(input$button1, {
      event <- "ON"
      js$processing3()
      httr::POST(openhab_url, body = event, encode = "json")
    }) 
    
    observeEvent(input$button2, {
      event <- "OFF"
      js$processing3()
      httr::POST(openhab_url, body = event, encode = "json")
    })
    
    
    blueprint <- 
    
    output$blueprint <- renderImage({
      filename <- here("panels","environmental","Engine2.png")
      
      list(src = filename)
    }, deleteFile = FALSE)
    
    

   
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