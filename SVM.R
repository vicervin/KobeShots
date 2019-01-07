library(e1071)
shots<-read.csv('data/data.csv')

# Skip the competition rows kept by Kaggle
shots<-shots[!is.na(shots$shot_made_flag),]
summary(shots)

#TODO matchup , home or visiting? 
shots$local_or_visitor<-'local'
shots[grep('@',shots$matchup),]$local_or_visitor<-'visitor'
shots$matchup<- NULL

#library(onehot)
shots[,"shot_made_flag"]<-factor(shots[,"shot_made_flag"])
shots$team_name <- NULL
shots2 <- data.frame(x =shots[,c("loc_x","loc_y","shot_distance", "minutes_remaining")], y=as.factor(shots$shot_made_flag))
shots2 <- shots2[sample(seq_len(nrow(shots2)), size = floor(0.1 * nrow(shots2))),]
smp_size <- floor(0.75 * nrow(shots2))
train_ind <- sample(seq_len(nrow(shots)), size = smp_size)
train <- shots2[train_ind, ]
test <- shots2[-train_ind, ]

svmfit=svm(y~., data=train, kernel="linear", cost=0.1,scale=FALSE)
plot(svmfit , shots2)
summary(svmfit)

pred = predict(svmfit, test)
table(predict=pred, truth=test$y)

tune.out=tune(svm,y~.,data=shots2,kernel="linear",ranges=list(cost=c(0.001, 0.01, 0.1, 1,5,10,100)))
summary(tune.out)

bestmod=tune.out$best.model
ypred=predict(bestmod ,test)
table(predict=ypred, truth=test$y)
