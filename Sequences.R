shots<-read.csv('data/data.csv')

# Skip the competition rows kept by Kaggle
shots<-shots[!is.na(shots$shot_made_flag),]

# Create sequences by game_date
# period -> minutes remaining -> seconds remaining
max.seconds <- max(shots$period)*12*60
shots$time <- shots$period*12*60-shots$minutes_remaining*60-shots$seconds_remaining


# Filling diracs with Ts of 1 second per game, BAD IDEA 
# Explanation follows... 

#for (game in shots$game_id){
#  shot.sequence <- rep(0,max.seconds)
#  game.shots<-shots[shots$game_id == game,]
#  shot.sequence[game.shots$seconds]<-game.shots$shot_made_flag
#  rbind(shot.sequences , shot.sequence)
#}

# Let's visualize the game with most shots
shots.per.game <- as.data.frame(table(shots$game_id))
most.shots.game<- which(shots.per.game$Freq == max(shots.per.game$Freq))
game.with.most.shots<-shots.per.game[most.shots.game,]$Var1

plot(shots[shots$game_id == game.with.most.shots,]$time,
     shots[shots$game_id == game.with.most.shots,]$shot_made_flag,
     pch = 16)



# Maybe the time is not so important for creating a sequence, 
# Kobe depends on another 4 guys to shoot, he can't shoot
# every second , so filling the 0s would be adding rubish noise.
# maybe it's important as a factor
plot(shots$time,
     shots$shot_made_flag,
     pch = 16)


abline(v=12*60) # End of quarters
abline(v=2*12*60)
abline(v=3*12*60)
abline(v=4*12*60)
