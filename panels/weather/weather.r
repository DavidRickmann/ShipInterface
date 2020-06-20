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
      title = NULL,
      subtitle = "Atmospheric Conditions",
      corners = 4, 
      sides = c(3,4),
      left_inputs = NULL,
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
      htmlOutput(ns("text"))
      )
    )
  ),
  fluidRow(
    lcarsBox(
      title = NULL,
      subtitle = NULL,
      corners = c(1), 
      sides = c(1,4),
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
        htmlOutput(ns("tempTitle")),
        plotOutput(ns("plot1"))
      ),
      fluidRow(
        column(6),
        column(6,
          htmlOutput(ns("rainTitle")),
          plotOutput(ns("plot2"))
        )
      )
    )
  )
  )
}

weatherpanel <- function(id) {
  moduleServer(id, function(input, output, session) {
    library(waiter)
    library(weatherr)
    library(tidyverse)
    library(jsonlite)
    library(dplyr)
    
    
    
    # header box bits
    
    output$text <- renderUI({HTML(paste("Hello", "everyone", sep = '<br/>')) })
    
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
    
    
    
    #body box bits

    
    output$tempTitle <- renderUI({HTML("AIR TEMPERATURE FORECAST") })
    output$plot1 <- renderPlot(ggplot(weather, aes(x=time, y=temp_air)) + 
                      geom_line(aes(color =  "#FFCC99")) + 
                      theme_lcars_dark() + 
                      theme(legend.position = "none", 
                            axis.title.x=element_blank(),
                            axis.title.y=element_blank() 
                            )    
                      )
    
    rain <- weather %>% select(time, precip_1hr) %>% head(24)
    
    output$rainTitle <- renderUI({HTML("PRECIPITATION FORECAST") })     
    output$plot2 <- renderPlot(ggplot(rain, aes(x=time, y=precip_1hr)) + 
                      geom_line(aes(color =  "#FFCC99")) + 
                      theme_lcars_dark() + 
                        theme(legend.position = "none", 
                              axis.title.x=element_blank(),
                              axis.title.y=element_blank()
                        )     )
         
     
   
   
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