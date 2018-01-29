library(DBI)
library(dygraphs)
library(xts)
library(shiny)
library(shinythemes)
library(dplyr)
library(pool)

con <- pool::dbPool(odbc::odbc(), dsn = "Postgres (DSN)")
bitcoin <- tbl(con, "bitcoin")

codes <- c("USD", "JPY", "CNY", "SGD", "HKD", "CAD", "NZD", 
           "AUD", "CLP", "GBP", "DKK", "SEK", "ISK", "CHF", 
           "BRL", "EUR", "RUB", "PLN", "THB", "KRW", "TWD")

ui <- fluidPage(
  theme = shinytheme("paper"),
  titlePanel("Bitcoin Exchange Rates"),
  sidebarLayout(
    sidebarPanel(
      selectInput("code", "Exchange Code:", choices = codes)
    ),
    mainPanel(align="center",
      dygraphOutput("dygraph", width = "100%", height = "275px"),
      p(),
      textOutput("asof")
    )
  )
)

server <- function(input, output) {

  dat <- reactive({
    bitcoin %>%
      filter(name == input$code) %>%
      select(timestamp, last, symbol) %>%
      collect
  })
  
  tseries <- reactive({
    xts(dat()$last, dat()$timestamp)
  })
  
  lab <- reactive({
    paste0("Bitcoin (", dat()$symbol[1], ")")
  })

  output$dygraph <- renderDygraph({
    dygraph(tseries(), main = lab()) %>%
      dyOptions(axisLineWidth = 1.5, 
                fillGraph = TRUE, 
                drawGrid = FALSE, 
                colors = "steelblue", 
                axisLineColor = "darkgrey", 
                axisLabelFontSize = 15) %>%
      dyRangeSelector(fillColor = "lightsteelblue", strokeColor = "white")
  })
  
  output$asof <- renderText({
    paste("Data as of:", as.character(max(dat()$timestamp)))
  })
  
}

shinyApp(ui = ui, server = server)
