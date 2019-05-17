rm(list = ls())
library(caret)
library(MASS)
library(ROCR)
library(e1071)
library(plotROC)
library(ggplot2)
library(rpart.plot)
library(rpart)


# 1
library(ISLR)
set.seed(42)

sub <- createDataPartition( College$Private, p = 0.8, list = FALSE )
train <- College[ sub, ]
test <- College[ -sub, ]
rm( sub )


model <- train(Private ~ .,  data=train, method="glm", family="binomial")
cm <- confusionMatrix(predict(model, newdata = train, type="raw"), data = train$Private, positive = 'Yes')
cm$byClass['Sensitivity']  # sensitivity (0.9627193)
1 - cm$byClass['Specificity'] # False positive rate (0.07831325)
cm$byClass['Pos Pred Value'] # precision (0.9712389)


cm <- confusionMatrix(predict(model, newdata = test, type="raw"), data = test$Private, positive = 'Yes')
cm$byClass['Sensitivity']  # sensitivity (0.9310345)
1 - cm$byClass['Specificity'] # False positive rate (0.1282051)
cm$byClass['Pos Pred Value'] # precision (0.9557522)

# As we can notive there is a little overfitting on the train set
# And the performance on the test set is a little bit worse in terms of
# both sensitivity, fpr, and precision


# 2
library(mlbench)
set.seed(42)
data(Shuttle)

sub <- createDataPartition( Shuttle$Class, p = 0.8, list = FALSE )
train <- Shuttle[ sub, ]
test <- Shuttle[ -sub, ]
rm( sub )

knn.fit <- train( Class~., 
                  data = train, 
                  method = 'knn', 
                  metric = 'Accuracy',
                  trControl = trainControl( "cv", number = 5 ), 
                  tuneLength = 20)
plot( knn.fit )
knn.fit$bestTune
confusionMatrix(predict(knn.fit, newdata = train, type="raw"), data = train$Class) # Accuracy : 0.9988
confusionMatrix(predict(knn.fit, newdata = test,  type="raw"), data = test$Class) # Accuracy : 0.9978

# In both cases the accuracy is pretty high so we don't have any overfitting
# And the model is pretty accurate in terms of its performance -> Accuracy : 0.9978
# on the test set


# 3
library(ISLR)
set.seed(42)

showConfusionMatrixAndROC <- function(model, data, add=FALSE) {
  cm = confusionMatrix(predict(model, newdata = data, type="raw"), data = data$Private, positive = 'Yes')
  print(cm)
  pred <- prediction(predict(model, newdata = data, type = "prob")[, 2], data$Private)
  cat(sprintf("AUC: %f\n", performance(pred, measure = "auc")@y.values))
  plot(performance(pred, "tpr", "fpr"), add=add); abline(0, 1, lty = 2)
}
data <- College


cltree <- train(Private ~ ., 
               data = data, 
               method = "rpart", 
               metric = 'Accuracy',
               trControl = trainControl(method = "cv", number = 5),
               tuneLength = 20)

rpart.plot(cltree$finalModel)
showConfusionMatrixAndROC(cltree, data) # Accuracy : 0.9189
                                        # AUC: 0.982902


model <- train(Private ~ ., 
               data = data, 
               method = "rf", 
               metric = 'Accuracy',
               trControl = trainControl(method = "cv", number = 3),
               tuneLength = 5)
showConfusionMatrixAndROC(model, data) # Accuracy : 1
                                       # AUC: 1


showConfusionMatrixAndROC(cltree, data)
showConfusionMatrixAndROC(model, data, add = TRUE)
# I highly doubt that the second model can actually perform 100% if we'd have train/test split
# It probably overfitted on the cross validation
# So from the numbers and plots the second model - random forest outperforms the first one
# But that doesn't necessarily mean that the second model is better than the first one
# As we might have overfitted on the train/val split during the cross validation

