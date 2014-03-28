load_nsvf_data <- function() {
  read.csv('./../Data/nsvf map data.csv', na.string=c("", " ", "  "),
    stringsAsFactors=F, header=T
  )
}