remove_negative <- function(x) {
  gsub('-', '', x)
}

percents_without_negative <- function(x) {
  remove_negative(percent(x))
}