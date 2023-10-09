library(plumber)

rm(list = ls())

version <- "1.0.0"

#* @apiTitle PDF Generation service

#* @param pid The person id, for example 12345 or 56789
#* @get /pdf
function(pid = 12345, res){
  if (is.null(pid)) {
    res$status <- 400 # Client error
    return(list(error = "pid parameter is required, it is person id"))
  }
  
  setwd("./pdf")
  tryCatch(
    {
      # Specifying expression
      source("data.R")
      templateName = "report.Rnw"
      
      env = parent.frame()
      env$param_pid = pid
      
      knitr::knit(templateName, envir = env, output = "output.tex")
      tools::texi2pdf("output.tex")
      
      res$setHeader("Content-type", "application/pdf")
      res$setHeader("Content-Disposition",
                    "attachment;filename=report.pdf")
      
      tmp = "output.pdf"
      res$body <- readBin(tmp, "raw", n = file.info(tmp)$size)    
      return(res)
    },
    error = function(e) {
      # Specifying error message
      print(e)
      res$status = 500 # Client error
      return(list(error = "Internal Server Error"))
    },
    finally = {
      # Specifying final
      setwd("..")
    }
  )
}
