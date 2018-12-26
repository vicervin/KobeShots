shots<-read.csv('data/data.csv')
source("plotCourt.R")
plot.court(55.5)
points(shots[shots$shot_made_flag == 1,]$loc_x , 
       shots[shots$shot_made_flag == 1,]$loc_y , 
       pch ='.',
       col='green')
points(shots[shots$shot_made_flag == 0,]$loc_x , 
       shots[shots$shot_made_flag == 0,]$loc_y , 
       pch ='.',
       col='red')
