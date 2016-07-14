
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(highcharter)
shinyUI(fluidPage(
  # Application title
  titlePanel("Đồ thị giao dịch cổ phiếu thời gian thực (chỉ update realtime từ 8h30 đến 15h)"),
  sidebarLayout(fluid = TRUE,
                sidebarPanel(
                  selectInput("theme", label = "Giao diện đồ thị", width = "100%",
                              choices = c(FALSE, "fivethirtyeight", "economist",
                                          "darkunica", "gridlight", "sandsignika",
                                          "null", "handdrwran", "chalk","google", "sparkline")),
                  selectInput("kl", label = "Số lần khớp lệnh gần nhất", width = "100%",
                              choices = c("10","20", "30", "40", "50", "100", "all")), width = 3)
                ,
                mainPanel(
                  highchartOutput("stockPlot")
                )
  )
))
