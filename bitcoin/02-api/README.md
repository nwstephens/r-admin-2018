# Plumber API Examples

Plumber allows you to create a web API by merely decorating your existing R source code with special comments. Take a look at an example.

## sql-query

Query the flights database using SQL syntax. Return airport information.

* [/endpoint/sqlquery?code=LAX](http://54.149.163.100:3939/endpoint/sqlquery?code=LAX)

```
#' @get /sqlquery
#' @param code Airport code (DCA; LAX; DFW)
function(code="DCA"){
  q1 <- dbSendQuery(con, "SELECT * FROM airports WHERE faa = ?")
  dbBind(q1, list(code))
  dbFetch(q1)
}
```

## dplyr-query

Query the flights database using dplyr syntax. Return total flights by month and carrier.

* [/endpoint/dplyrquery?carrier=LAX&month=99](http://54.149.163.100:3939/endpoint/dplyrquery?carrier=LAX&month=99)

```
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
```

## earnings

Access the IEX API for quarterly earnings. Return a ggplot png for stock ticker and peers.

* [/endpoint/earnings?ticker=GE](http://54.149.163.100:3939/endpoint/earnings?ticker=GE)

```
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
```

## bitcoin

Access the blockchain API for exchange rates. Return a datatable.

* [/endpoint/bitcoin](http://54.149.163.100:3939/endpoint/bitcoin)

```
#' @get /bitcoin
#' @serializer htmlwidget
function(){
  js <- fromJSON("https://blockchain.info/ticker")
  df <- map_dfr(js, c, .id="name")
  datatable(df)
}
```



