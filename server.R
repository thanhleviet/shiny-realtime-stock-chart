
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(jsonlite)
library(RCurl)
library(highcharter)
library(lubridate)

url <- "http://stockboard2.sbsc.com.vn/ChartHandler.ashx?Type=6&Symbol=SHI&callback=jQuery111007833975924922852_1468462142295&_search=false&nd=1468462901871&rows=200&page=1&sidx=&sord=asc&_=1468462142344"

getStock <- function(url){
  stock_data <- getURL(url,.opts = list(timeout = 10000)) %>% gsub("jQuery111007833975924922852_1468462142295\\(|\\)|;","",.) %>% fromJSON(.)
  # rs <-  list(records = stock_data$records, rows = stock_data$rows)
  .rs <- stock_data$rows$row %>% arrange(desc(id))
  return(.rs)
}

checkTime <- function(){
  this_time <- function(){
    .now <- now()
    .h <- .now %>% hour()
    .m <- .now %>% minute()/60
    return(.h + .m)
  }
  ato <- 8.5
  atc <- 15.0
  this_time <- this_time()
  return(this_time > ato & this_time < atc)
}

plotStock <- function(input, stock_data, limit = TRUE, n, sub_title){
  # stock_data <- stock_data
  if (limit) {
    if (nrow(stock_data) >= n) {
      stock_data <- tail(stock_data, n)
    }
  }

  hc <- highchart() %>%
    hc_xAxis(categories = stock_data$time) %>%
    hc_yAxis_multiples(
      list(title = list(text = "Price"),
           align = "left",
           showFirstLabel = FALSE,
           showLastLabel = FALSE,
           marker = list(enabled = FALSE)
      ),
      list(title = list(text = "Khối lượng cổ phiếu"),
           align = "righ",
           showFirstLabel = FALSE,
           showLastLabel = FALSE,
           opposite = TRUE
      )) %>%

    hc_add_series(name = "SHI Volume", data = stock_data$vol/100, type = "column", yAxis = 1) %>%
    hc_title(text = "SHI Stock") %>%
    hc_subtitle(text = sub_title, style = list(color = "#2b908f", fontWeight = "bold")) %>%
    hc_add_series(name = "SHI price", data = stock_data$price, type = "spline")

  if (input$theme != FALSE) {
    theme <- switch(input$theme,
                    null = hc_theme_null(),
                    darkunica = hc_theme_darkunica(),
                    gridlight = hc_theme_gridlight(),
                    sandsignika = hc_theme_sandsignika(),
                    fivethirtyeight = hc_theme_538(),
                    economist = hc_theme_economist(),
                    chalk = hc_theme_chalk(),
                    google = hc_theme_google(),
                    handdrwran = hc_theme_handdrawn()
    )

    hc <- hc %>% hc_add_theme(theme)
  }
  hc
}
shinyServer(function(input, output) {

  st_dt <- getStock(url)
  sub_title <- paste0("Updated at ",now())

  output$stockPlot <- renderHighchart({
    n <- input$kl
    if (is.na(n)) {
      n <-  50
    }
    else if (n == "all") {
      n <- nrow(st_dt)
    }
    else{
      n <- as.numeric(n)
    }
    invalidateLater(60000)
    if (checkTime()) {
      st_dt <- st_dt_update <- getStock(url)
      plotStock(input = input, stock_data = st_dt_update, sub_title = sub_title, n = n)
    }
    else {
      plotStock(input = input, stock_data = st_dt, sub_title = sub_title, n = n)
    }
  })
})
