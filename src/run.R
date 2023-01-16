library(plumber)
# 'plumber.R' is the location of the file shown above
# pr("plumber.R") %>%
pr <- plumb("./plumber.R")
#pr <- plumb("./rlang-docker/src/plumber.R")
pr$run(host = "0.0.0.0", port = 8000)


