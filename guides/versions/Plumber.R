library(plumber)
library(aws.s3)
library(dplyr)
library(tidyr)
library(purrr)

f <- function(x){
  get_bucket(
    bucket = 'docs.rstudio.com',
    prefix = x,
    max = Inf
  )
}

# RSPM
#' @get /rspm
function(x){
f("rspm/admin/rstudio-pm") %>%
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
#' @get /rsc
function(x){
f("connect/admin/rstudio-connect") %>%
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

# IDE
#' @get /ide
function(x){
f("ide/server-pro/rstudio-server-pro") %>%
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

# rsconnect::deployAPI("guides/versions", account = "nathan", server = "colorado.rstudio.com")
