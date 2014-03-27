load_data <- function() {
  read.csv(file="./../Data/FILENAME.csv", head=TRUE, na.string=c("", " ", "  "))
}