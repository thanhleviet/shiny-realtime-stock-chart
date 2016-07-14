
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(highcharter)
shinyUI(fluidPage(
  # Application title
  titlePanel("Biểu đồ giao dịch cổ phiếu thời gian thực"),
  sidebarLayout(fluid = TRUE,
                sidebarPanel(
                  selectInput("theme", label = "Theme", width = "100%",
                              choices = c(FALSE, "fivethirtyeight", "economist",
                                          "darkunica", "gridlight", "sandsignika",
                                          "null", "handdrwran", "chalk","google")),
                  selectInput("kl", label = "Khớp lệnh", width = "100%",
                              choices = c("10","20", "30", "40", "50", "100", "all")), width = 3)
                ,
                mainPanel(
                  h3(textOutput("Tự động cập nhật trong phiên giao dịch")),
                  highchartOutput("stockPlot")
                )
  )
))
