library(httr)

event <- "pump_on"
event <- "pump_off"

key <- "eVhl3KyQZEPX_mrZARK9e0fs8rd_l2BtUhOx7hRl6ww"

maker_url <- paste('https://maker.ifttt.com/trigger', event, 'with/key', key, sep='/')
httr::POST(maker_url)

