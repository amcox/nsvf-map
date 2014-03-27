library(ggplot2)
library(reshape2)
library(gdata)

update_functions <- function() {
	old.wd <- getwd()
	setwd("functions")
	sapply(list.files(), source)
	setwd(old.wd)
}
update_functions()

df <- read.csv('./../Data/nsvf map data.csv', na.string=c("", " ", "  "))

dm <- melt(df, measure.vars=c("boy", "moy", "eoy"), variable.name="period", value.name="perc")
dm$quart <- reorder(dm$quart, new.order=c("2nd Quartile", "Bottom Quartile", "3rd Quartile", "Top Quartile"))
dm <- dm[order(as.numeric(dm$quart)),]
dm$perc.flipped <- apply(dm, 1, function(r){
  if(r['quart'] == "2nd Quartile" || r['quart'] == "Bottom Quartile"){
    return(as.numeric(r['perc']) * -1)
  }else{
    return(as.numeric(r['perc']))
  }
})
cut_sign <- function(vec) {
  cut(vec, c(-9999999, 0, 99999999),
    labels=c("bottom", "top"), right=F
  )
}
dm$half <- factor(cut_sign(dm$perc.flipped))

# ds <- subset(dm, school == 'ReNEW Cultural Arts Academy')
ds <- subset(dm, subject == 'reading')

ggplot()+
  geom_bar(data=subset(ds, half == 'top'), aes(x=period, y=perc.flipped, fill=quart), stat="identity")+
  geom_bar(data=subset(ds, half == 'bottom'), aes(x=period, y=perc.flipped, fill=quart), stat="identity")+
  scale_fill_manual(values=quart.pal)+
  theme_bw()+
  facet_grid(grade ~ school, labeller=label_wrap_gen(width=15))
  
# TODO: Make the bottom quartiles negative so they fall below the x axis
# TODO: Slopegraph for percent at 50th percentile from period to period (maybe each quartile, to)