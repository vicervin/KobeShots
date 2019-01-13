shots<-read.csv('data/data.csv')
source("plotCourt.R")
# 55.5 is the y offset in inches of the court
# corresponds to the center of the basket ring.
plot.court()

points(shots[shots$shot_made_flag == 1,]$loc_x , 
       shots[shots$shot_made_flag == 1,]$loc_y , 
       pch ='.',
       col='green')
points(shots[shots$shot_made_flag == 0,]$loc_x , 
       shots[shots$shot_made_flag == 0,]$loc_y , 
       pch ='.',
       col='red')

# Shot frequency vs distance
plot( aggregate (shot_made_flag ~ shot_distance, data = shots, FUN = sum),
      type = 'h',
      main = "Frequency of shots vs Distance",
      xlab = "Distance in feet",
      ylab = "Frequency"
      )

plot( aggregate (shot_made_flag ~ shot_distance, data = shots, FUN = mean),
      type = 'h',
      main = " Scoring Accuracy vs Distance",
      xlab = "Distance in feet",
      ylab = "Accuracy "
)



