library(ggplot2)
library(maps)
library(mapdata)
library(mapplots)

freq <- read.table('freq.df', header=T)


map('worldHires', ylim=c(-6,70), xlim=c(-120,140), col='gray', fill=FALSE)

for (i in 1:26){
  add.pie(z=c(freq$Allele_A[i], freq$Allele_T[i]), x=freq$long[i], y=freq$lat[i], radius=freq$N_CHR[i]/100, col=c(alpha("orange", 0.6), alpha("blue", 0.6)), labels="")
  i=i+1
}


legend('topright', c('Freq. Allele: A', 'Freq. Allele: T'), pch=16, col=c(alpha("orange", 0.6), alpha("blue", 0.6)), cex=0.8, bty='0', pt.cex=1)



########### Example pie

add.pie(z=c(0.68, 0.32), x=-59.5412, y=13.1776, radius=sqrt(192), col=c(alpha("orange", 0.6), alpha("blue", 0.6)), labels="")

#z indicates the portions of the pie charts filled by each given type, x & y are coordinates for the point, and radius is to designate the size of the circle for the pie chart

#to plot all points, I run a loop to run through my data one point at a time and make each pie chart; there are most likely more efficient methods
















################### GGPLOT2 VERSION  #####################################
world <- map_data('world')

world_base <- ggplot(data=world) + geom_polygon(aes(x=long, y=lat, fill=I('white'), group=group), color='gray') + coord_fixed(1.1, ylim=c(-9.2,62), xlim=c(-113,140)) + guides(fill=FALSE)

world_base

## This plots points
world_base + geom_point(data=freq, aes(x=long, y=lat), color='blue', cex=freq$N_CHR/100, alpha=7/10)


## Here we will plot pies
world_base + geom_scatterpie(data=freq, aes(x=long, y=lat), group=freq$superpop, radius=1, cols=c("Allele_A", "Allele_T"), alpha=7/10)

