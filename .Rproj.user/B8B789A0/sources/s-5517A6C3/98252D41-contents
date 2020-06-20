  library(lcars) 
  library(ggplot2)

#This wrapper is required until shiny v1.5 is released.
moduleServer <- function(id, module) {
  callModule(module, id)
}


#write a standard nav button function
#get the colours from the theme?
#allow assignation of standard colours in the config

weatherpanelUI <- function(id) {
  use_waiter() # include dependencies
  waiter_show_on_load()
  uiOutput(NS(id, "panel"))
}

weatherpanel <- function(id) {
  moduleServer(id, function(input, output, session) {
    library(waiter)
    library(weatherr)
    library(tidyverse)
    library(jsonlite)
    library(dplyr)
    
    
    #get weather
    #yeah this should be in a function and location should be a variable but this'll do to get the system back up and running
    #also needs error handling on the API call.
    weather_URL <- 'http://api.met.no/weatherapi/locationforecast/2.0/complete?lat=51.484940&lon=-0.301890&altitude=28'
    weather <- jsonlite::fromJSON(weather_URL)
    #we might want to seperate out the instant/12hour/6hour/1hour data but for now I'm just gonna flatten it all and sort it out later
    weather <- jsonlite::flatten(weather$properties$timeseries)
    #clean it up a bit
    colnames(weather) <- c("time","pressure","temp_air",
                           "cloudcover","cloudcover_high","cloudcover_low","cloudcover_medium",
                           "dewpoint","fog","humidity","uv","winddirection","windspeed",
                           "symbol_12hr","symbol_1hr","precip_1hr",
                           "symbol_6hr","temp_air_max_6hr","temp_air_min_6hr","precip_6hr")
    
    
    weather$time <- parse_date_time(weather$time,"Ymd HMS")
    #weathernow <- weather %>%
    #  filter(row_number()==1) 
    
    
    
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
         waiter_show( # show the waiter
           spin_fading_circles() # use a spinner
         ),
         renderPlot(ggplot(weather, aes(x=time, y=temp_air)) + 
                      geom_line(aes(color =  "#FFCC99")) + 
                      theme_lcars_dark() + 
                      theme(legend.position = "none") ),
         
         renderPlot(ggplot(weather, aes(x=time, y=precip_1hr)) + 
                      geom_line(aes(color =  "#FFCC99")) + 
                      theme_lcars_dark() + 
                      theme(legend.position = "none") ),
         
       waiter_hide()
         ),
       title = "Atmospheric Conditions",
       subtitle = "Predicted Temperature",
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
    weatherpanelUI("wp1")
  )
  server <- function(input, output, session) {
    weatherpanel("wp1")
  }
  shinyApp(ui, server)  
}


panelApp()