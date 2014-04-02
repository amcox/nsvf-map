library(devtools)
library(ggplot2)
library(reshape2)
library(gdata)
library(scales)
library(plyr)

update_functions <- function() {
	old.wd <- getwd()
	setwd("functions")
	sapply(list.files(), source)
	setwd(old.wd)
}
update_functions()

df <- load_nsvf_data()
df$school <- clean_up_school_names(df$school)
df <- df[order(df$school),]
# Remove the eoy so that there aren't zeros in the plot.
# Will need to change for when eoy data arrives
df <- df[, names(df)[!names(df) %in% c("eoy")]]

# Remove any rows that don't have all periods
# since the plot function turns NA into 0
df <- df[complete.cases(df),]

dm <- melt(df, measure.vars=c("boy", "moy"), variable.name="period", value.name="perc")

# Find the percent of students at or above the 50th percentile
dt <- ddply(dm, .(cmo, school, grade, subject, period), function(d){
  d.s <- subset(d, quart %in% c("Top Quartile", "3rd Quartile"))
  sum(d.s$perc)
})
names(dt) <- c(names(dt)[1:(length(names(dt))-1)], "perc.above.median")

make_slopegraph_plot <- function(d){
  # Find the grade and subject in the df that is passed
  sub <- unique(d$subject)[1]
  grd <- unique(d$grade)[1]
  ds <- d[, c("school", "period", "perc.above.median")]
  ds <- subset(ds, !is.na(perc.above.median))
  dk <- build_slopegraph(ds, x="period", y="perc.above.median", group="school", method="tufte", min.space=0.05)
  dk$y <- round(dk$y, digits=2)
  p <- plot_slopegraph(dk)+labs(title=paste0("MAP ", simpleCap(sub), "\nGrade ", grd))
  save_plot_as_pdf_with_dims(p, paste0("Tufte Slopegraph MAP, ", simpleCap(sub), " Grade ", grd), w=4, h=10.5)
}
ddply(subset(dt, !is.na(perc.above.median)), .(grade, subject), make_slopegraph_plot)

# Make and save data for the python method
ds <- dt[, c("subject", "grade", "school", "period", "perc.above.median")]
ds$perc.above.median <- round(ds$perc.above.median, 2) * 100
dc <- dcast(ds, subject + grade + school ~ period)
# Once saved, manually move to 'data' folder
save_df_as_csv(dc, "all map percs")


