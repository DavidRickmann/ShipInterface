

#2357

trekcolors::lcars_2357()




#here
library(here)
here("res", "beep.js")



library(jsonlite)
library(dplyr)
library(lubridate)
weather_URL <- 'http://api.met.no/weatherapi/locationforecast/2.0/complete?lat=51.484940&lon=-0.301890&altitude=28'
weather <- jsonlite::fromJSON(weather_URL)
weather <- jsonlite::flatten(weather$properties$timeseries)
colnames(weather) <- c("time","pressure","temp_air",
                           "cloudcover","cloudcover_high","cloudcover_low","cloudcover_medium",
                           "dewpoint","fog","humidity","uv","winddirection","windspeed",
                           "symbol_12hr","symbol_1hr","precip_1hr",
                           "symbol_6hr","temp_air_max_6hr","temp_air_min_6hr","precip_6hr")


weather$time <- parse_date_time(weather$time,"Ymd HMS")


weather2 <- weather %>% select(time, precip_1hr) %>% head(12)


ggplot(weather2, aes(x=time, y=precip_1hr)) + 
  geom_line(aes(color =  "#FFCC99")) + 
  theme_lcars_dark() + 
  theme(legend.position = "none") 

library(future)
plan(multiprocess)

weather.async <- function() {
  future({locationforecast(51.484940,-0.301890)})
}

?weatherr


weather <- reactive({
  weather.async() %...>%
    head(input$n)
})



#Tide Data - stormglass

keys <- get("auth")

lat <- 51.484940
long <- -0.301890

url = paste0("https://api.stormglass.io/v2/tide/sea-level/point?lat=",lat,"&lng=",long, "&start=2020-06-17&end=2020-06-18")


httpResponse <- GET(url, add_headers(Authorization = API_KEY), accept_json())
results = fromJSON(content(httpResponse, "text"))
result2 <- (results$data)

results3 <- data.frame(t(sapply(result2,c))) %>% unnest(cols = c(time,sg))

results3$time <- parse_date_time(results3$time, "Ymd HMS z")

ggplot(results3, aes(x=time, y=sg)) + 
  geom_line(aes(color =  "#FFCC99")) + 
  theme_lcars_dark() + 
  theme(legend.position = "none") 
