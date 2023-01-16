getSampleData <- function(param){
  ret <- list(
    "field1" = paste(param, "1"),
    "field2" = paste(param, "2")
  )
  return(ret)
}