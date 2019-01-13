source("utilities.R")
shots<-read.csv('data/data.csv')

# Skip the competition rows kept by Kaggle
shots<-shots[!is.na(shots$shot_made_flag),]


# TODO 
# A lot of the data is numeric, apparently the naiveBayes from e1071
# deals only with discrete data, so we could discretize the values 
# say of position, time and all the 'more' continuous variables into
# ranges.


#- Preprocess the data-----------------------------------------------

#TODO matchup , home or visiting? 
shots$local_or_visitor<-'local'
shots[grep('@',shots$matchup),]$local_or_visitor<-'visitor'
shots$matchup<- NULL

# Drop some numeric values
shots$game_event_id <- NULL
shots$game_id <- NULL

shots$lon <- NULL
shots$lat <- NULL

shots$team_id <- NULL
shots$game_date <- NULL
shots$shot_id <- NULL

# Turn some numeric into factors
shots$season <- as.factor(shots$season)
shots$playoffs <- as.factor(shots$playoffs)

# Turn the scoring flag into a factor

shots[shots$shot_made_flag == 1,]$shot_made_flag<-'Yes'
shots[shots$shot_made_flag == 0,]$shot_made_flag<-'No'
shots$shot_made_flag<-as.factor(shots$shot_made_flag)



summary(shots)

#-------------------------------------------------------------------

# Train 60 , test 20, validate 20
ind.obj<-split.indices(0.6 , 0.2, 0.2, nrow(shots))
train <- shots[ind.obj$train, ]
test <- shots[ind.obj$test, ]
validate <- shots[ind.obj$validate, ]

#-Naive Bayes-------------------------------------------------------
# install.packages('e1071')
library(e1071)
NB_shots<-naiveBayes(shot_made_flag ~ . , data = train)
NB_shots

pred <- predict (NB_shots, test)

# Output of results------------------------------------------------
print.c.m (pred, test$shot_made_flag)

# Explore the results---
# parameters for likelihoods of the distance given the classes
t(NB_shots$tables$shot_distance)

# ----Examining the types of shots
types<-as.data.frame(t(NB_shots$tables$combined_shot_type))
colnames(types)[3]<- 'P(X_i|Y)'
types[order(types$`P(X_i|Y)`, decreasing = TRUE),]

print("Validation test")
pred.validate <- predict(NB_shots,validate)
print.c.m (pred.validate, validate$shot_made_flag)

