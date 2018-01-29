# myfile.R

library(DBI)
library(dygraphs)
library(shiny)
library(jsonlite)
library(DT)
library(tidyverse)

con <- dbConnect(odbc::odbc(), "Postgres (DSN)")

#' @get /sqlquery
#' @param code Airport code (DCA; LAX; DFW)
function(code="DCA"){
  q1 <- dbSendQuery(con, "SELECT * FROM airports WHERE faa = ?")
  dbBind(q1, list(code))
  dbFetch(q1)
}


#' @get /dplyrquery
#' @param month Month (1-12; 99)
#' @param carrier Airline carrier (DL; AA; WN)
function(month = 1, carrier = "DL"){
  db_flights <- tbl(con, "flights") %>%
    left_join(tbl(con, "airlines"), by = "carrier") %>%
    rename(airline = name) %>%
    left_join(tbl(con, "airports"), by = c("origin" = "faa")) %>%
    rename(origin_name = name) %>%
    select(-lat, -lon, -alt, -tz, -dst) %>%
    left_join(tbl(con, "airports"), by = c("dest" = "faa")) %>%
    rename(dest_name = name)
  if(month != 99) {
    result <- db_flights %>%
      filter(month == month,
             carrier == carrier) %>%
      group_by(day) %>%
      tally() %>%
      collect()
    group_name <- "Daily"
  } else {
    result <- db_flights %>%
      filter(carrier == carrier) %>%
      group_by(month) %>%
      tally() %>%
      collect()    
    group_name <- "Monthly"
  } 
  pull(result, n)
}


#' @get /earnings
#' @param ticker Stock ticker (AAPL; GE; F; C)
#' @jpeg
function(ticker="AAPL"){
  peer_tickers <- get_peers(ticker)
  all_tickers <- c(ticker, head(peer_tickers, 6))
  earnings <- get_earnings(all_tickers)
  dat <- map(earnings, "earnings") %>%
    map(2) %>%
    map_dfr(data.frame, .id = "stock") %>%
    mutate(EPSReportDate = as.Date(EPSReportDate)) %>%
    select(stock, EPSReportDate, actualEPS) %>%
    drop_na
  p <- ggplot(dat, aes(EPSReportDate, actualEPS, color = stock)) + 
    geom_line() +
    labs(x = "", y = " Earnings", title = "Quarterly Earnings")
  print(p)
}
get_peers <- function(y){
  x <- "https://api.iextrading.com/1.0/stock/"
  z <- "/peers"
  url <- paste0(x, y, z)
  fromJSON(url)
}
get_earnings <- function(y){
  x <- "https://api.iextrading.com/1.0/stock/market/batch?symbols="
  z <- "&types=earnings"
  url <- paste0(x, paste(y, collapse = ","), z)
  fromJSON(url)
}

#' @get /bitcoin
#' @serializer htmlwidget
function(){
  js <- fromJSON("https://blockchain.info/ticker")
  df <- map_dfr(js, c, .id="name")
  datatable(df)
}
# rsconnect::deployAPI("api", account = "rstudio")

