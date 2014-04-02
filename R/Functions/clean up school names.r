clean_up_school_names <- function(vec) {
  vec <- gsub("DC Prep-", "DCP: ", vec)
  vec <- gsub("Rocketship", "RSHP:", vec)
  vec <- gsub("ReNEW Cultural Arts Academy", "ReNEW: RCAA", vec)
  vec <- gsub("SciTech Academy", "ReNEW: STA", vec)
  vec <- gsub("Dolores T Aaron Elementary", "ReNEW: DTA", vec)
  vec <- gsub("Schaumburg Elementary", "ReNEW: SCH", vec)
  vec <- gsub("KIPP DC", "KIPP DC:", vec)
  return(vec)
}