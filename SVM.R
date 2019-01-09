# Utilities, printing confusion matrix , metrics.
source("utilities.R")

library(e1071)
shots<-read.csv('data/data.csv')

# Skip the competition rows kept by Kaggle
shots<-shots[!is.na(shots$shot_made_flag),]
summary(shots)

#TODO matchup , home or visiting? 
shots$local_or_visitor<-1.0
shots[grep('@',shots$matchup),]$local_or_visitor<-0.0
shots$matchup<- NULL

#library(onehot)



# Preprocess the columns
string.columns <- c('action_type',
             'combined_shot_type',
             'season',
             'shot_type',
             'shot_zone_area',
             'shot_zone_basic',
             'shot_zone_range',
             'game_date',
             'opponent'
             )
# Turn string columns to numbers
shots[,string.columns]<-lapply(shots[,string.columns], function(x) as.numeric(x))
# Turn the target variable to a factor
shots$shot_made_flag<-as.factor(shots$shot_made_flag)
# Remove columns because they have the same level for all the data
# Kobe only played at LAL
shots$team_id <- NULL
shots$team_name <- NULL


excluded.columns <- c('shot_made_flag')
shots2 <- data.frame(x = shots[,- which(names(shots) %in% excluded.columns)], 
                     y = as.factor(shots$shot_made_flag))

#shots2 <- shots2[sample(seq_len(nrow(shots2)), size = floor(0.1 * nrow(shots2))),]

# --------------------------------------------------------------------------------
# Train 60 , test 20, validate 20
ind.obj<-split.indices(0.6 , 0.2, 0.2, nrow(shots2))
train <- shots2[ind.obj$train, ]
test <- shots2[ind.obj$validate, ]
# --------------------------------------------------------------------------------
# Fitting the SVM 
svmfit <- svm(y~., data=train, kernel="sigmoid", cost=0.1)
#plot(svmfit , shots2)
summary(svmfit)
pred <- predict(svmfit, test)
print.c.m(pred,test$y)

# --------------------------------------------------------------------------------
# Hyper parameter optimization
tuning.cost <- c(0.001, 0.01, 0.1, 1,5,10,100)
tuning.kernel <- c('linear','polynomial','radial basis','sigmoid')
tune.out <- tune(svm,y~. ,
                 data = shots2 ,
                 ranges = list( cost = tuning.cost, kernel = tuning.kernel))
summary(tune.out)

bestmod <- tune.out$best.model
ypred <- predict(bestmod , test)
print.c.m(ypred , test$y)
