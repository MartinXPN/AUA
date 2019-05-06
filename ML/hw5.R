rm(list = ls())
library(caret)
library(MASS)
library(ROCR)
library(e1071)
library(plotROC)
library(ggplot2)
library(rpart.plot)
library(rpart)

set.seed(42)
german_credit = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data")

colnames(german_credit) = c("chk_acct", "duration", "credit_his", "purpose", 
                            "amount", "saving_acct", "present_emp", "installment_rate", "sex", "other_debtor", 
                            "present_resid", "property", "age", "other_install", "housing", "n_credits", 
                            "job", "n_people", "telephone", "foreign", "response")

# 2 = positive, 1 = negative => subtract 1 from both and make 0 = negative, 1 = positive
german_credit$response = german_credit$response - 1
german_credit$response <- as.factor(german_credit$response)


sub <- createDataPartition( german_credit$response, p = 0.8, list = FALSE )
train <- german_credit[ sub, ]
test <- german_credit[ -sub, ]
rm( sub, german_credit )

showConfusionMatrixAndROC <- function(model, data) {
  cm = confusionMatrix(predict(model, newdata = data, type="raw"), data = data$response, positive = '1')
  print(cm)
  pred <- prediction(predict(model, newdata = data, type = "prob")[, 2], data$response)
  plot(performance(pred, "tpr", "fpr")); abline(0, 1, lty = 2)
}

# 1
ctrl = trainControl(method = "cv", number = 10)
model <- train(response ~ ., data = train, method = "rpart", trControl = ctrl)
ggplot(model)
rpart.plot(model$finalModel)

showConfusionMatrixAndROC(model = model, data = train)
showConfusionMatrixAndROC(model = model, data = test)


# 2
model <- train(response ~ ., data = train, method = 'rf', ntree = 5)
showConfusionMatrixAndROC(model = model, data = train)
showConfusionMatrixAndROC(model = model, data = test)


# 3
model <- train(response ~ ., data = train, method = 'adaboost', tuneGrid=expand.grid(nIter=10, method='adaboost'))
showConfusionMatrixAndROC(model = model, data = train)
showConfusionMatrixAndROC(model = model, data = test)


# 4
# rpart    - Pos Pred Value (precision) : 0.2333
# rf       - Pos Pred Value (precision) : 0.4667
# adaboost - Pos Pred Value (precision) : 0.3000

# The best one was the model with method = 'rf'