library(shiny)
library(ggplot2)
library(showtext)
library(config)
library(httr)
library(rtrek)
library(lcars)
library(shinyjs)
library(V8)
library(here)
library(waiter)
library(keyring)

#options(shiny.port = 7775)
options(shiny.host = "127.0.0.1")  # SET THIS TO LOCAL IP ADDRESS
#font_add_google("Oswald", "Oswald")
showtext_auto()

ship <- get("vessel")

source("panels/environmental/environmental.r")
source("panels/library/library.r")
source("panels/weather/weather.r")
source("panels/tasks/tasks.r")

ui <- lcarsPage(
  lcarsHeader(
  title = paste(ship$name," - ",ship$registration),
  color = "mariner",
  title_color = "neon-carrot",
  background_color = "#000000",
  title_right = TRUE,
  title_invert = FALSE,
  round = c("both", "right", "left", "none"),
  width = "100%"
),

fluidRow(),
fluidRow(),

#load sound functions
useShinyjs(),
extendShinyjs(script = "panels/beep.js"),

#load main panel
uiOutput("panel")  
  
 
)





server <- function(input, output, session) {

  #navigation functions ----
  
  v <- reactiveValues(panel = "home")
  
  observeEvent(input$Home, {
     v$panel <- "home"
     js$beep()
  }) 
  
  observeEvent(input$Library, {
    v$panel <- "library"
    js$beep()
  }) 

  observeEvent(input$Environmental, {
    v$panel <- "environmental"
    js$beep()
  }) 
  
  observeEvent(input$Weather, {
    v$panel <- "weather"
    js$beep()
  })   
  
  
  observeEvent(input$Tasks, {
    v$panel <- "tasks"
    js$beep()
  })   
  
  observeEvent(input$Sensors, {
   # v$panel <- "sensors"
    js$denybeep()
  }) 
  
  
  navbutton <- function(panel) {
    lcarsButton(
      panel,
      panel,
      icon = NULL,
      color = "neon-carrot",
      hover_color = "mariner",
      width = 150
    )
  }
  
  navcol <- inputColumn(
    navbutton("Home"),
    navbutton("Library"),
    navbutton("Environmental"),
    navbutton("Weather"),
    #navbutton("Sensors"),
    navbutton("Tasks")
  )

  librarypanel("lp1")
  environmentpanel("ep1", config = ship)
  weatherpanel("wp1")
  taskpanel("tp1")
  
  output$panel <- renderLcarsBox({
    
    if ( v$panel == "home") {
      return(panel_home)
    } else if (  v$panel == "library") {
      return(librarypanelUI("lp1"))
    } else if ( v$panel == "environmental") {
      return(environmentpanelUI("ep1"))
    } else if ( v$panel == "weather") {
      return(weatherpanelUI("wp1"))
    } else if ( v$panel == "tasks") {
      return(taskpanelUI("tp1"))
    }
    
    
    
# end ----    
    
    
  })
  
  
  
  panel_home <- lcarsBox(
      fluidRow(
        
        
        
      ),
      title = NULL,
      subtitle = "LCARS Command Interface V 0.01",
      corners = c(1,2,3,4), 
      sides = c(1,2,3,4),
      left_inputs = NULL,
      right_inputs = navcol,
      color = "anakiwa",
      side_color = "anakiwa",
      title_color = "mariner",
      subtitle_color = "mariner",
      title_right = TRUE,
      subtitle_right = FALSE,
      clip = FALSE,
      width_left = 150,
      width_right = 150
    )
 
  

  

   

  

  
  
  
}


shinyApp(ui = ui, server = server)