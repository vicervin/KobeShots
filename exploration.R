
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
#Plot the accuracy vs distance
plot( aggregate (shot_made_flag ~ shot_distance, data = shots, FUN = mean),
      type = 'h',
      main = " Scoring Accuracy vs Distance",
      xlab = "Distance in feet",
      ylab = "Accuracy "
)

# Plot the accuracy vs distance + distributions of distance for misses and scores
# coming from naive bayes
plot( aggregate (shot_made_flag ~ shot_distance, data = shots, FUN = mean),
      type = 'h',
      main = " Scoring Accuracy vs Distance",
      xlab = "Distance in feet",
      ylab = "Accuracy "
)
par(new = TRUE)
scores<-seq(0,80)
scores.density<-dnorm(scores,mean = 11.432232, sd = 9.249154)
misses.density<-dnorm(scores,mean = 15.139665, sd = 9.230344)
plot(scores,scores.density, axes = false, type="l", lwd=1, col='green')
lines(scores,misses.density, axes = FALSE, type="l", lwd=1, col='red')
