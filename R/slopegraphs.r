library(devtools)
library(ggplot2)
library(reshape2)
library(gdata)
library(scales)
library(plyr)

install_github("leeper/slopegraph")
library(slopegraph)

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

dm <- melt(df, measure.vars=c("boy", "moy", "eoy"), variable.name="period", value.name="perc")

dt <- ddply(dm, .(cmo, school, grade, subject, period), function(d){
  d.s <- subset(d, quart %in% c("Top Quartile", "3rd Quartile"))
  sum(d.s$perc)
})

names(dt) <- c(names(dt)[1:(length(names(dt))-1)], "perc.above.median")

# The leeper way
ds <- subset(dt, subject == 'reading' & grade == 0)
ds <- ds[, c("school", "period", "perc.above.median")]
ds$perc.above.median <- ds$perc.above.median * 100
dw <- dcast(ds, school ~ period)

d1 <- dw[,2:3]
row.names(d1) <- dw$school
d1 <- d1[complete.cases(d1),]

# The jkeirstead method
ds <- subset(dt, subject == 'reading' & grade == 0)
ds <- ds[, c("school", "period", "perc.above.median")]

