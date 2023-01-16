library(plumber)
library(sessioninfo)
library(jsonlite)

Sys.setlocale("LC_TIME", "C")
version <- "0.0.0"

#* @apiTitle PDF Generation service

#* Get PDF report
#* @param param The param
#* @get /pdf
function(param, res) {
  if (is.null (param)) {
    res$status <- 400 # Client error
    return(list(error = "param parameter is required"))
  }
  
  setwd("./pdf")
  source("data.R")
  
  res$setHeader("Content-type", "application/pdf")
  res$setHeader("Content-Disposition",
                "attachment;filename=report.pdf")
  
  env <- parent.frame()
  env$param_p <- param
  
  templateName = paste("report", ".Rnw", sep = "")
  
  tryCatch({
    knitr::knit(templateName, envir = env, output = "output.tex")
    tools::texi2pdf("output.tex")
    tmp = "output.pdf"
    res$body <- readBin(tmp, "raw", n = file.info(tmp)$size)
  },
  error = function(err) {
    res$status <- 500 # Server error
    return(list(error = "failed to generate pdf"))
  },
  finally = {
    setwd("..")
  })
  
  return(res)
}


### Service functions
#* Ping or health check
#* @get /_ping
function(res) {
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- ""
  return(res)
}

#* @get /_version
function(res) {
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- sprintf('{"version":"%s"}', version)
  return(res)
}

#* @get /_sessioninfo
function(res) {
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- jsonlite::toJSON(
    sessioninfo::session_info(), auto_unbox = TRUE, null = "null"
  )
  return(res)
}

