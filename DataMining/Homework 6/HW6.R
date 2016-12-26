# Decision trees
# The dataset voting contains information about the voting
# patterns of Democrat and Republican parties in US Congress.
# You can find more information in the description file.

#1. Load the voting_test and voting_train datasets into R.
# Get rid of the spaces and other symbols in the column 
# names using function make.names. You shold get names like
# this: el.salvador.aid. Look at the help of the function
# for the details. (6.25)
library( rpart)
library( rpart.plot )
library( rattle )
library( lattice )
library( ggplot2 )
library( caret )
library( ROCR )
load( 'voting_train.rda' )
load( 'voting_test.rda' )
colnames( v_train ) <- make.names( colnames(v_train) )
colnames( v_test ) <- make.names( colnames(v_test) )


#2. Create a decision tree with the library rpart on the 
# training set. Use the variable Class as dependent
#variable and all other variables as independent. (6.25)
model <- rpart( Class ~ ., data = v_train, method = 'class' )


#3. Plot the decision tree with the library prp and 
# rattle. Make sure you are getting clear and legible 
# plot without overlapping nodes. (6.25)
prp( model, type = 1, extra = 1, faclen = 8, main = "" ) # ugly plot
fancyRpartPlot( model )                                  # fancy plot

#4. Make prediction on the testing set. Report the accuracy
# of your model. Take republican as a positive class. (6.25)
predictions <- predict( model, newdata = v_test, type = 'class' )
confusionMatrix( predictions, v_test$Class, positive = 'republican' ) # 0.8056 accuracy
rm( predictions )

#5. Now start playing with differnet parameters of your
# tree (cp, minbucket, minsplit). Your goal is to get a 
# better model than the first one, i.e. the accuracy
# of your model should be higher than the initial one. (6.25)
model2 <- rpart( Class ~ ., data = v_train, method = 'class', cp = 0.5 )
predictions <- predict( model2, newdata = v_test, type = 'class' )
confusionMatrix( predictions, v_test$Class, positive = 'republican' ) # 0.8333 accuracy
rm( predictions )

#6. Is the second model doing better job in predicting
# affiliation for democratic or republican party? Explain.
# (6.25)
# true positive rate of model2 is higher by 2
# true negative rate of model1 is higher by 1
# sum of false predictions of model 1 is higher than sum of false predictions of model2
# => overall model2 is better

#7. What are the rules to classify a congressmen as a 
#democrat? (6.25)
asRules( model2 )

#8. Using your last model, plot the ROC and calculate
# the area under the curve. Use republican as the class
# of interest. (6.25)
prediction_probabilities <- predict( model2, newdata = v_test, type = 'prob' )
predictions <- prediction( prediction_probabilities[,'republican'], v_test$Class )
perf <- performance( predictions, "tpr", "fpr" )

plot( perf )
performance( predictions, "auc" )@y.values # 0.8160173
rm( list = ls() )
# perhaps the graphs of model and model2 are almost the same and the @y.values for
# model = 0.8225108 => model has slightly better performanse if we look at only AUC
# but the difference is almost 0 => accuracy is more important


#9.BONUS! (10)
# Using library caret, come up with the most optimal
# value of cp to use it in the decision tree for ebay 
# problem. You need to do cross validation 
# in order to find that value. We had this kind of problem
# in KNN homework. Report your findings.

library( caret )
train_control <- trainControl(method = "repeatedcv",   # Use cross validation
                              number = 10,             # Use 10 partitions
                              repeats = 2)             # Repeat 2 times

tune_grid = expand.grid(cp=c(0.001))

tree <- train(Class ~ .,
                        data=v_train,
                        method="rpart",
                        trControl= train_control,
                        tuneGrid = tune_grid,
                        maxdepth = 5,
                        minbucket=5)
tree # 0.928398
# cp = 0.001