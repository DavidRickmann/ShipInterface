  library(lcars) 
  library(ggplot2)

#This wrapper is required until shiny v1.5 is released.
moduleServer <- function(id, module) {
  callModule(module, id)
}


#write a standard nav button function
#get the colours from the theme?
#allow assignation of standard colours in the config

librarypanelUI <- function(id) {
  use_waiter() # include dependencies
  waiter_show_on_load()
  
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
        fluidRow(column(10,
                    htmlOutput(ns("inc"))
                )
        ),
        title = "Data Retrieval",
        subtitle = "Introduction",
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
  )
  
  
}
  
  
  
  
  
  
  
  
  



librarypanel <- function(id) {
  moduleServer(id, function(input, output, session) {
    library(waiter)
    
    #library functions
    
    getPage<-function() {
      return(includeMarkdown("panels/library/library.rmd"))
    }
    
    output$inc<-renderUI({getPage()})
    
    
   
    
    
  })
     
}



panelApp <- function() {
  ui <- lcarsPage(
    librarypanelUI("lp1")
  )
  server <- function(input, output, session) {
    librarypanel("lp1")
  }
  shinyApp(ui, server)  
}


panelApp()