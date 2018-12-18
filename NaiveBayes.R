shots<-read.csv('data/data.csv')

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
# Turn the scoring flag into a factor

shots[shots$shot_made_flag == 1,]$shot_made_flag<-'Yes'
shots[shots$shot_made_flag == 0,]$shot_made_flag<-'No'
shots$shot_made_flag<-as.factor(shots$shot_made_flag)

# Skip the competition rows kept by Kaggle
shots<-shots[!is.na(shots$shot_made_flag),]

summary(shots)

#-------------------------------------------------------------------



#-Naive Bayes-------------------------------------------------------
#install.packages('e1071')
library(e1071)
NB_shots<-naiveBayes(shot_made_flag ~ . , data = shots)
NB_shots


NB_preds <- predict (NB_shots, shots)
# Confusion matrix
table(NB_preds,shots$shot_made_flag)
