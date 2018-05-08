library(plumber)
library(aws.s3)
library(dplyr)
library(tidyr)
library(purrr)

pulldata <- function(x){
  get_bucket(
    bucket = 'docs.rstudio.com',
    prefix = x,
    max = Inf
  )
}

prods <- c(
  "rspm/admin/rstudio-pm", 
  "connect/admin/rstudio-connect", 
  "ide/server-pro/rstudio-server-pro",
  "shiny-server/1"
  )

dat <- map(prods, pulldata)

# RSPM
#' @get /RSPM
function(x){
dat[[1]] %>%
  map_chr("Key") %>%
  as_tibble %>%
  filter(grepl("rstudio.*\\.pdf$", value)) %>%
  separate(value, letters[1:6], sep = "-") %>%
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

# RSC
#' @get /RSC
function(x){
dat[[2]] %>%
  map_chr("Key") %>%
  as_tibble %>%
  filter(grepl("rstudio.*\\.pdf$", value)) %>%
  separate(value, letters[1:6], sep = "-") %>%
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

# RSP
#' @get /RSP
function(x){
dat[[3]] %>%
  map_chr("Key") %>%
  as_tibble %>%
  filter(grepl("rstudio.*\\.pdf$", value)) %>%
  separate(value, letters[1:7], sep = "-") %>%
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

# SSP
#' @get /SSP
function(x){
dat[[4]] %>%
  map_chr("Key") %>%
  as_tibble %>%
  filter(grepl("shiny.*\\.pdf$", value)) %>%
  separate(value, letters[1:3], sep = "/") %>%
  rename(version = b) %>%
  mutate(url = paste0(
    "http://docs.rstudio.com/shiny-server/",
    version,
    "/index.pdf")
  ) %>%
  select(url, version)
}

# rsconnect::deployAPI("guides/versions", account = "nathan", server = "colorado.rstudio.com")
