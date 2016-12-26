# Homework 5- KNN
# The dataset Cancer.csv contains data about the tumor cells for 
# 100 patients. The independent variables are different
# characteristics of the tumor cells. The dependant variable
# is diagosis_result, which has two classes: B and M (benign and
# malignant). Our goal is to create the model to identify whether
# the patient has type B or type M cancer. 
# Attention!!!- while solving the problems, make sure to set the 
# seed to 2016 every time when you are using a function that
# does any random operation. 

#1. Load the data to R and scale it. (5.5)
cancer <- read.csv( 'Cancer.csv' )
cancer[1:8] <- scale( cancer[1:8] )

#2. Set seed to 2016. Create testing and training sets. 
# 80% of data should go to train, the rest to test.
# Make sure the proportions of the categorical variable are 
# not changed (some small variation is ok). (5.5)
library( lattice )
library( ggplot2 )
library( 'caret' )
set.seed( 2016 )
sub <- createDataPartition( cancer$diagnosis_result, p = 0.8, list = FALSE ) # diagnosis_result is dependent variable
train <- cancer[ sub, ]                                               # create train set
test <- cancer[ -sub, ]                                               # create test set
rm( sub )
summary( train$diagnosis_result )
summary( test$diagnosis_result )

#3. Using library caret, identify the optimal number of K's.
# Do repeated k-fold cross validation.
# Use the accuracy for defining which number is the best.
# Also, do not forget to set seed to 2016. (5.5)

set.seed( 2016 )
control <- trainControl( "repeatedcv", number = 10, repeats = 3 )

set.seed( 2016 )
knn <- train( diagnosis_result~., 
              data = train, 
              trControl = control, 
              method = 'knn', 
              tuneGrid = expand.grid( k = 2 : 12 ) )
plot( knn )
knn$bestTune

#4. Now do the same analysis, but use AUC (area under the curve)
# for identifying which number of K's is the best. 
# Is that number the same as in the prvious case?
# Again, set the seed to 2016. (5.5)
library( pROC )
library( ROCR )
set.seed( 2016 )
control2 <- trainControl( "repeatedcv", 
                          number = 10, 
                          repeats = 3, 
                          classProbs = TRUE, 
                          summaryFunction = twoClassSummary )

set.seed(2016)
knn2 <- train( diagnosis_result~., 
              data = train, 
              trControl = control2, 
              method = 'knn', 
              tuneGrid = expand.grid( k = 2 : 12 ) )
plot( knn2 )
knn2$bestTune

#5. Based on the results in the previous two problems, choose
# the most optimal number of K's. Run KNN classification
# using the library class. (5.5)
# As both models showed that k = 7 is the most optimal solution
# Imma chose k = 7 nigga
library( class )
set.seed( 2016 )
best_model <- knn( train[1:8], test[1:8], train$diagnosis_result, k = 7, prob = TRUE)

#6. What is the accuracy of that model? Use the confusionMatrix
# to get the number. The positive class is M. (5.5)
confusionMatrix( best_model, test$diagnosis_result, positive = 'M' )
# Accuracy : 0.8947

#7. Look at the sensitivity and specificty of the models. 
# Explain their meanings within the context of the problem.
# How will you deal with the classification threshold to balance
# the risk of having false negative and false positive results?
# Explain. (5.5)

# Sensitivity : 0.9167         TP rate
# Specificity : 0.8571         FP rate
attr( best_model, 'prob' )
# this method shows that only in 2 cases there were 3 positive and 4 negative neighbours
# and we can pick a probability threshold of 0.7


#8. Now solve the same classification problem using logistic
# regression. What is the accuracy of your model? (5.5)
model <- glm( diagnosis_result~., data = train, family = 'binomial' )
summary( model )
predictions <- predict( model, newdata = test, type = 'response' )
pr_label <- ifelse( predictions > 0.5, 'M', 'B' )
confusionMatrix( pr_label, test$diagnosis_result, positive = 'M' ) # get all parameters -> sensitivity, specificity, accuracy...

#9. Which classsification model works better? 
# Compare several accuracy measures from confusion matrix and 
# give your thoughts. (6)

#                knn     glm
# Accuracy    : 0.8947  0.8421
# Sensitivity : 0.9167  0.8333
# Specificity : 0.8571  0.8571

# => knn is better with both accuracy measure and sensitivity.
# both have the same specificity