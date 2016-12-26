# The dataset credit contains information about the bank customers.
# It is used to identify whether a customer who applied for the
# loan will default or not.

#1. Load credit data into R. Make sure the categorical
# variables are factored. Create testing and training 
# datasets, so that 80% of data goes to train and the rest
# goes to test.Make sure the proportions of the dependent 
# variable are fixed. Set the seed to 2016. (7)
credit <- read.csv( 'Credit.csv' )
credit$ed <- factor( credit$ed, 
                     levels = c( 1, 2, 3, 4, 5 ), 
                     labels = c( 'No high school', 'High school', 'College', 'Undergraduate', 'Postgraduate' ) )
credit$default <- factor( credit$default,
                          levels = c( 0, 1 ), 
                          labels = c( 'No', 'Yes' ) )

library( caret )
set.seed( 2016 )
sub <- createDataPartition( credit$default, p = 0.8, list = FALSE )
train <- credit[ sub, ]
test <- credit[ -sub, ]
rm( sub )

#2. Create a naive bayes model on the dataset. Set 
# Laplace equal to 1. What is the accuracy of the model? (7)
library( e1071 )
model <- naiveBayes( default~., data = train, laplace = 1 )
predictions <- predict( model, newdata = test )
prediction_probabilities <- predict( model, newdata = test, type = 'raw' )
confusionMatrix( predictions, test$default ) # Accuracy : 0.741
rm( predictions )


#3. Plot the ROC curve, make sure you have the colors of the
# thresholds on the curve. Give explanation to the coloring of
# the curve: what does it show?? What is the AUC? (7)
library( ROCR )
res <- prediction( prediction_probabilities[,1], 
                   test$default, 
                   label.ordering = c( 'Yes', 'No' ) )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform, colorize=T )
performance( res, 'auc' )@y.values # 0.7208738
rm( prediction_probabilities )
rm( perform )
# Best threshold is about 0.3 (on X axes)
# the false positive rate is not that big and true positive is higher
# closer to red => flase positive rate is small 
# close to blue => false positive rate is big
# we want a threshold to be as close to red and as high as possible


#4. Given that someone defaulted, what is the probability that
# he/she has postgarduate degree? (7)
model # 0.01315789
# Y     No high school High school    College Undergraduate Postgraduate
# No      0.56324582  0.25775656 0.11694511    0.05011933   0.01193317
# Yes     0.40789474  0.32894737 0.18421053    0.06578947   0.01315789



#5.Take any of the classification methods that we studied so
# far and build a model using it. Compare that model with the
# Naive Bayes model. Which one does better? Comment. (7)
linearModel <- glm( default ~ ., data = train, family = 'binomial' )
linear_probabilities <- predict( linearModel, newdata = test, type = 'response' )
linear_predictions <- ifelse( linear_probabilities < 0.5, 'No', 'Yes' )
confusionMatrix( linear_predictions, test$default ) # Accuracy : 0.7986
rm( linear_probabilities )
rm( linear_predictions )
# logistic regression model is better by about 0.05%
# It may be because naive bias is good when predicting outliers, but in this sample
# we try to make a simple classification ( not detect outliers )


#6. Load the scoring datset into R. Our goal will be to give
# credit scores (defualting probabilities) to the potential
# customers. Predict the scores with the Naive Bayes model. (8)
scoring <- read.csv( 'Scoring.csv' )
scoring$ed <- factor( scoring$ed, 
                     levels = c( 1, 2, 3, 4, 5 ), 
                     labels = c( 'No high school', 'High school', 'College', 'Undergraduate', 'Postgraduate' ) )
scoring$default <- predict( model, newdata = scoring, type = 'raw' ) # [1] = No [2] = Yes

#7. Identify the top 25% of customers that are least risky.
# Describe them with the variables you have in the scoring dataset.(7)
leastRisky <- scoring[ order(scoring$default[,2]), ][ 0:(nrow(scoring)/4), ]


# Bonus point
#8. Compare top 25% of risky customers (Quartile 4) with bottom 25% of risky customers (Quartile 1). 
# What are the main differences you see? Generate 1-2 tables and graphs for the analysis. (10 points)
mostRisky <- scoring[ order(scoring$default[,1]), ][ 0:(nrow(scoring)/4), ]

library( ggplot2 )
table( mostRisky$ed ) # most of them are eigther with no high school edication or have a high school
                      # few of them have college education or undergrad. and there are no risky postgraduate people

table( leastRisky$ed ) # again most of the least risky people are from these two categories : No high school    High school
                        # this is mostly the cause of having a lot of people with no high school education in the dataset

qplot( leastRisky$age )
qplot( mostRisky$age ) # no much difference => doesn't depend on age

qplot( leastRisky$creddebt, binwidth = 0.1 )
qplot( mostRisky$creddebt, binwidth = 0.1 ) # distribution is almost the same => doesn't depend on creddebt too

qplot( leastRisky$income )
qplot( mostRisky$income ) # again no significant difference
