library(lubridate)
library(jsonlite)
library(ggplot2)


# Read the JSON data from file
persons = fromJSON("personality.json")
data = fromJSON("data.json")


escSpecLatexChar <- function(x) {
  if ( is.na(x) ||  is.null(x) )  return( "  ")
  if (typeof(x) == "list" && is.null(x[[1]])) return("  ")
  if (typeof(x) == "list") {x =unlist(x)[1]}
  escapedValue = ifelse(typeof(x) == "character", xtable::sanitize(x), x)
  return(escapedValue) 
}


getPersonInformation = function(df, personId) {
  # Subset the data based on the _id field
  df1 = df[df$`_id` == personId,] 
  
  info = list(
    "fullName" = escSpecLatexChar(df1[["name"]][["text"]]),
    "birthDate" = escSpecLatexChar(df1[["birthDate"]]),
    "gender" = escSpecLatexChar(df1[["gender"]]),    
    "email" = escSpecLatexChar(sapply(df1$emails, function(x) x$address)),
    "phone" = escSpecLatexChar(df1[["phone"]])
  )
  return(info)
}



dotChart = function(df) {
  list( 
    geom_point(data = df,
               aes(category, mean, shape = "1"),
               color = "black"),
    geom_line(data = df,
              aes(x = category, y = mean, group = 1),
              color = "black",
              show.legend = T),
   geom_bar(data = df,
             aes(category, value, fill = "steelblue"),
             stat = "identity",
             alpha = 0.4),
    geom_text(data = df,
              aes(x = category, y = value, label = value),vjust = -0.2)
  )
}

paramChart = function() {
  list(
    theme_bw(),
    labs(x = "Category", y = "Value"),
    theme(legend.spacing.y = unit(-3, "mm")),
     scale_shape_manual(name = '', labels = "Mean", values = 16),
     scale_fill_manual(name = '', labels = "Value", values = "blue"),
     guides(fill = guide_legend(override.aes = list(linetype = 0, alpha = 0.4)))
  )
}

getChart = function(df) {
    ggplot() +
    dotChart(df) +
    paramChart()
}

