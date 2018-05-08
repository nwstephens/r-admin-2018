#' @apiTitle RStudio admin docs
#' @apiDescription Access current and past documentation for RStudio products.
#' @apiVersion 0.1.0

library(plumber)
library(aws.s3)
library(dplyr)
library(tidyr)
library(purrr)
library(lubridate)
library(stringr)

timestamp1 <- date()

prods <- c(
  "rspm/admin/rstudio-pm", 
  "connect/admin/rstudio-connect", 
  "ide/server-pro/rstudio-server-pro",
  "shiny-server/1"
)

pulldata <- function(path){
  get_bucket(
    bucket = 'docs.rstudio.com',
    prefix = path,
    max = Inf
  )
}

formatdata <- function(dat){
    map(dat, function(dd) {c(file = dd$Key, date = dd$LastModified)}) %>%
    reduce(rbind) %>%
    as_tibble %>%
    filter(grepl("\\.pdf$", file)) %>%
    mutate(
      lastmod = as_datetime(date),
      pulldate = timestamp1,
      prod = str_extract(file, "[^/]+"),
      order = row_number()
    )
}

dat <- prods %>%
  map(pulldata) %>%
  map(formatdata) %>%
  reduce(rbind) %>%
  select(pulldate, prod, order, file, lastmod)

#' Docs for all RStudio professional products
#' @get /rstudio-admin-guides
#' @param product RStudio Product (rspm; connect; ide; shiny-server)
function(product) {
  dat2 <- dat %>%
    filter(prod == product)
  if(product == "rspm"){
    dat2 %>%
      separate(file, letters[1:6], sep = "-") %>%
      separate(f, c("f", "g"), sep = "\\.") %>%
      rename(version = e, build = f) %>%
      mutate(url = paste0(
        "http://docs.rstudio.com/rspm/admin/rstudio-pm-admin-guide-",
        version,
        "-",
        build,
        ".pdf")
      ) %>%
      select(url, version, build)
  } else if (product == "connect") {
    dat2 %>%
      separate(file, letters[1:6], sep = "-") %>%
      separate(f, c("f", "g"), sep = "\\.") %>%
      rename(version = e, build = f) %>%
      mutate(url = paste0(
        "http://docs.rstudio.com/connect/",
        version,
        "/admin/rstudio-connect-admin-guide-",
        version,
        "-",
        build,
        ".pdf")
      ) %>%
      select(url, version, build)
  } else if (product == "ide") {
    dat2 %>%
      separate(file, letters[1:7], sep = "-") %>%
      rename(version = e) %>%
      mutate(url = paste0(
        "http://docs.rstudio.com/ide/server-pro/",
        version,
        "/rstudio-server-pro-",
        version,
        "-admin-guide.pdf")
      ) %>%
      select(url, version)  
  } else if (product == "shiny-server") {
    dat %>%
      filter(prod == "shiny-server") %>%
      separate(file, letters[1:3], sep = "/") %>%
      rename(version = b) %>%
      mutate(url = paste0(
        "http://docs.rstudio.com/shiny-server/",
        version,
        "/index.pdf")
      ) %>%
      select(url, version)
  } else {
    print("Invalid input")
  }
}

#' Docs for RStudio Package Manager
#' @get /rspm
function(x){
  dat %>%
    filter(prod == "rspm") %>%
    separate(file, letters[1:6], sep = "-") %>%
    separate(f, c("f", "g"), sep = "\\.") %>%
    rename(version = e, build = f) %>%
    mutate(url = paste0(
      "http://docs.rstudio.com/rspm/admin/rstudio-pm-admin-guide-",
      version,
      "-",
      build,
      ".pdf")
    ) %>%
    select(url, version, build)
}

#' Docs for RStudio Connect
#' @get /connect
function(x){
  dat %>%
    filter(prod == "connect") %>%
    separate(file, letters[1:6], sep = "-") %>%
    separate(f, c("f", "g"), sep = "\\.") %>%
    rename(version = e, build = f) %>%
    mutate(url = paste0(
      "http://docs.rstudio.com/connect/",
      version,
      "/admin/rstudio-connect-admin-guide-",
      version,
      "-",
      build,
      ".pdf")
    ) %>%
    select(url, version, build)
}

#' Docs for RStudio Server Pro
#' @get /ide
function(x){
dat %>%
    filter(prod == "ide") %>%
    separate(file, letters[1:7], sep = "-") %>%
    rename(version = e) %>%
    mutate(url = paste0(
      "http://docs.rstudio.com/ide/server-pro/",
      version,
      "/rstudio-server-pro-",
      version,
      "-admin-guide.pdf")
      ) %>%
    select(url, version)
}

#' Docs for Shiny Server and Shiny Server Pro
#' @get /shiny-server
function(x){
dat %>%
    filter(prod == "shiny-server") %>%
    separate(file, letters[1:3], sep = "/") %>%
    rename(version = b) %>%
    mutate(url = paste0(
      "http://docs.rstudio.com/shiny-server/",
      version,
      "/index.pdf")
    ) %>%
    select(url, version)
}

# rsconnect::deployAPI("guides/admin-docs", account = "nathan", server = "colorado.rstudio.com")
