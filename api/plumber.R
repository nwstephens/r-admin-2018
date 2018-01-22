# myfile.R

#* @get /mean
normalMean <- function(samples=10){
  data <- rnorm(samples)
  mean(data)
}

# rsconnect::deployAPI("api", account = "rstudio")
