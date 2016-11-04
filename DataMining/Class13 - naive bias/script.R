load( 'voting_train.rda' )  # load Train
load( 'voting_test.rda' )   # load Test

library( e1071 )

model <- naiveBayes( Class~., data = Train, laplace = 1 )
summary( model )
names( model )

model$apriori
model$tables

predictions <- predict( model, newdata = Test )                            # predict class labels
prediction_probabilities <- predict( model, newdata = Test, type = 'raw' ) # get probabilities of predictions

library( caret )
confusionMatrix( predictions, Test$Class ) # 0.8519 accuracy

library( ROCR )
res <- prediction( prediction_probabilities[,1], Test$Class, label.ordering = c( 'republican', 'democrat' ) )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform )


#SPAM
rm( list = ls() )
spam <- read.csv( 'spam.csv' )
spam$is_spam <- factor( spam$is_spam, levels = c( 0, 1 ), labels = c( 'No', 'Yes' ) )
library( caret )
set.seed( 2016 )
sub <- createDataPartition( spam$is_spam, p = 0.8, list = FALSE )
train <- spam[ sub, ]
test <- spam[ -sub, ]
rm( sub )


library( e1071 )
model <- naiveBayes( is_spam~., data = train, laplace = 1 )
names( model )

predictions <- predict( model, newdata = test )                            # predict class labels
prediction_probabilities <- predict( model, newdata = test, type = 'raw' ) # get probabilities of predictions
confusionMatrix( predictions, test$is_spam, positive = 'Yes' ) # 0.7116 accuracy


library( ROCR )
res <- prediction( prediction_probabilities[,1], test$is_spam, label.ordering = c( 'Yes', 'No' ) )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform )

performance( res, 'auc' )@y.values # 0.8857832



#Cancer
rm( list = ls() )
cancer <- read.csv( 'cancer_train.csv' )
cancer$Class <- factor( cancer$Class, levels = c( 0, 1 ), labels = c( 'No', 'Yes' ) )
library( caret )
set.seed( 2016 )
sub <- createDataPartition( cancer$Class, p = 0.8, list = FALSE )
train <- cancer[ sub, ]
test <- cancer[ -sub, ]
rm( sub )


library( e1071 )
model <- naiveBayes( Class~., data = train, laplace = 1 )
names( model )

predictions <- predict( model, newdata = test )                            # predict class labels
prediction_probabilities <- predict( model, newdata = test, type = 'raw' ) # get probabilities of predictions
confusionMatrix( predictions, test$Class, positive = 'Yes' ) # 0.7623 accuracy


library( ROCR )
res <- prediction( prediction_probabilities[,1], test$Class, label.ordering = c( 'Yes', 'No' ) )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform, colorize = TRUE )

performance( res, 'auc' )@y.values # 0.8434524



# Create logistic regression model
logistic_model <- glm( Class~., family = 'binomial', data = train )
logistic_predictions <- predict( logistic_model, newdata = test, type = 'response' )
pr_label <- ifelse( logistic_predictions > 0.5, 'Yes', 'No' )
ptest <- prediction( logistic_predictions, test$Class )
logistic_perform <- performance( ptest, 'tpr', 'fpr' )
plot( perform )

