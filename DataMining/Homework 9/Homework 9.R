# The following dataset consist of data on football games for 11
# european countries.  It covers time from 2011-2016. The variable
# result has two arguments: HDW- Home team didnt win, HW- Homw
# team won. Most of the data describes the players strength
# averaged for the last 7 games (prior to the given game) averaged
# by the team (those are only for players who participated in the
# game).  More information can be found here-
# http://sofifa.com/player/192883.  You can find a huge amount of
# analytics done on football data
# here-https://www.kaggle.com/hugomathien/soccer variables
# 'home_team_points', 'away_team_points' show the amount of the
# points the teams have earned before the game (3 for win, 1 for
# draw, 0 for lose) Variable stage shows the Round number during
# the season. The poitive case for the model is HW (home team
# won).

# Dont forget to set the seed everytime you run randomForest.
# Divide data into training and testing set,80% goes to train.
load( 'Soccer.rda' )
library( 'caret' )
library( e1071 )
library( ROCR )
set.seed( 2016 )
sub <- createDataPartition( soccer$result1, p = 0.8, list = FALSE )
train <- soccer[ sub, ]
test <- soccer[ -sub, ]
rm( sub )

# Question 1. Do some descriptive analytics (charts, tests, etc)
# to find interesting patterns in the data (10 points)
plot( soccer$home_balance )
cor( soccer$home_short_passing, soccer$away_short_passing )
cor( soccer$home_curve, soccer$away_curve )
cor( soccer$home_penalties, soccer$away_penalties ) # 0.3659584
chisq.test( table(soccer$result1, soccer$away_team_points) ) # they are correlated
hist( soccer$home_penalties )
hist( soccer$home_agility )

# Question 2. Build a
# random forest model with the package randomForest. Your goal is
# to predict the game result (variable 'result1') (15 points)
library(randomForest)
set.seed( 2016 )
model <- randomForest(result1~., data = train, ntree = 50 )
model # OOB estimate of  error rate: 37.76%


# 2.1 Develop randomForest model by tunning several parameters.
# Look for package help for more info.  Explain the meaning of
# each parameter.
#####################################################
# ntree: number of trees in random forest
# mtry: number of variables to try at every split
# do.trace: visualize the output
# importance: keep the importance metrices of variabels
# maxnodes: maximum nodes a leaf of a tree can have
set.seed( 2016 )
model1 <- randomForest(result1~., data = train, ntree = 50, mtry = 5 )
model1 # OOB estimate of  error rate: 37.23%
set.seed( 2016 )
model2 <- randomForest(result1~., data = train, ntree = 50, mtry = 5, nodesize = 100 )
model2 # OOB estimate of  error rate: 35.13%
set.seed( 2016 )
model3 <- randomForest(result1~., data = train, ntree = 50, mtry = 5, nodesize = 100, do.trace = TRUE )
model3 # OOB estimate of  error rate: 35.57%
set.seed( 2016 )
model4 <- randomForest(result1~., data = train, ntree = 50, mtry = 5, nodesize = 100, do.trace = TRUE, importance = TRUE )
model4 # OOB estimate of  error rate: 35.4%

# 2.2 Report on accuracy of your final chosen model (OOB
# estimate). Comment on it
# lower OOB => higher accuracy => model2 is better than the others


# 2.3 Report AUC on testing set.
pred <- predict( model2, newdata=test, type="prob" )
perf <- prediction( pred[,2], test$result1 )
performance( perf, "auc" )@y.values # 0.6972423

# 2.4 What are the most important variables?
varImpPlot( model2 )
# higher the MeanDecreaseGini => the variable is more important
# the 3 most important ones are: home_long_passing, home_ball_control, home_vision


# Question 3. Use caret to train randomforest model. Think about
# the hyperparameters you can use for model tuning.  Do grid
# search.Hint: play with expand.grid parameter.  Report the best
# model. (15 points).
ctrl <- trainControl( method = 'cv', number = 5, summaryFunction = twoClassSummary, classProbs = TRUE )
grid <- expand.grid( mtry = c(1, 3, 5, 7) )
fit <- train( result1 ~., data = train, method = 'rf', trControl = ctrl, tuneGrid = grid, metric = 'ROC' ) # It takes about 2-3 hours
fit
fit$bestTune


# Question 4. there is a package 'AUCRF' that uses randomForest
# but reports AUC on the OOB sets.  Use it to build randomforest
# model (10 points)
library( AUCRF )
model <- AUCRF( result1 ~., data = train )
summary( model )
plot( model )
??AUCRF

# Bonus question (15 points). 
# The variables in the dataset are the
# same measures of home and away teams. For example
# 'away_short_passing' and 'home_short_passing' are showing how
# good are both teams in short passing. Now think what kind of
# transformations can you do with the data to decrease the number
# of variables and get better model. Report your way of thinking
# and the final model.

# We can take the avarage of these variables
# Thus predicting how much is the value of this variable on avarage.
# In the example of short_passing we'll say ( away_showrt_passing + home_short_passing )/2