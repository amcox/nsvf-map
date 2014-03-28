library(ggplot2)
library(reshape2)
library(gdata)
library(scales)

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
# dm$quart <- reorder(dm$quart, new.order=c("2nd Quartile", "Bottom Quartile", "3rd Quartile", "Top Quartile"))
dm$quart <- factor(dm$quart, levels=sorting.quartiles)
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
dm$quart <- reorder(dm$quart, new.order=sorting.quartiles)

make_schools_grades_bar_plot <- function(d, s) {
  ds <- subset(d, subject == s)
  p <- ggplot()+
    geom_bar(data=subset(ds, half == 'top'), aes(x=period, y=perc.flipped, fill=quart), stat="identity")+
    geom_bar(data=subset(ds, half == 'bottom'), aes(x=period, y=perc.flipped, fill=quart), stat="identity")+
    scale_fill_manual(values=quart.pal, breaks=display.quartiles, name="Quartile")+
    scale_y_continuous(labels=percents_without_negative, breaks=seq(-1, 1, .2))+
    labs(
      title=paste0("Percent of Students by Quartile for MAP ", simpleCap(s), " by Grade and School"),
      x="Testing Cycle",
      y="Percent of Students"
    )+
    theme_bw()+
    theme(
      axis.text.x=element_text(size=6),
      strip.text.x=element_text(size=5),
      legend.text=element_text(size=6),
      legend.title=element_text(size=7)
    )+
    facet_grid(grade ~ school, labeller=label_wrap_gen(width=8))
  save_plot_as_pdf(p, paste0("MAP Quartile Percents by School and Grade, ", simpleCap(s)))
}

make_schools_grades_bar_plot(dm, 'reading')
make_schools_grades_bar_plot(dm, 'math')


  
# TODO: Slopegraph for percent at 50th percentile from period to period (maybe each quartile, to)