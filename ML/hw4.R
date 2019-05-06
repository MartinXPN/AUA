rm(list = ls())
library( caret )
library(MASS)
library(ROCR)
library( e1071 )

set.seed(42)
german_credit = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data")

colnames(german_credit) = c("chk_acct", "duration", "credit_his", "purpose", 
                            "amount", "saving_acct", "present_emp", "installment_rate", "sex", "other_debtor", 
                            "present_resid", "property", "age", "other_install", "housing", "n_credits", 
                            "job", "n_people", "telephone", "foreign", "response")

german_credit$response <- as.factor(german_credit$response)


sub <- createDataPartition( german_credit$response, p = 0.8, list = FALSE )
train <- german_credit[ sub, ]
test <- german_credit[ -sub, ]
rm( sub, german_credit )


# 1
lda.fit = lda(response ~., train)
plot(lda.fit)
lda.pred=predict(lda.fit, test)
table(test$response,lda.pred$class)

lda.pred <- prediction(lda.pred$posterior[,2], test$response) 
performance(lda.pred, "auc")@y.values
plot(performance(lda.pred,"tpr","fpr"),colorize=TRUE)


# 2
qda.fit = qda(response ~., data=train)
qda.pred=predict(qda.fit, test)
table(test$response,qda.pred$class)

qda.pred <- prediction(qda.pred$posterior[,2], test$response) 
performance(qda.pred, "auc")@y.values
plot(performance(qda.pred,"tpr","fpr"),colorize=TRUE)


# 3
naive.fit <- naiveBayes(response~., data = train)
naive.pred = predict(naive.fit, test, type = "raw")
naive.pred = prediction(naive.pred[,2], test$response)

performance(naive.pred, "auc")@y.values
plot(performance(naive.pred,"tpr","fpr"),colorize=TRUE)


# 4
logistic.fit <- glm(response~., data = train, family='binomial')
logistic.pred = predict(logistic.fit, test, type = "response")
logistic.pred = prediction(logistic.pred, test$response)

performance(logistic.pred, "auc")@y.values
plot(performance(logistic.pred,"tpr","fpr"),colorize=TRUE)


# 5
knn.fit <- train( response~., 
              data = train, 
              trControl = trainControl( "repeatedcv", number = 10, repeats = 3 ), 
              method = 'knn', 
              tuneGrid = expand.grid( k = 3 : 100 ) )
plot( knn.fit )
knn.fit$bestTune
knn.pred = predict(knn.fit, test, type = "prob")
knn.pred = prediction(knn.pred[,2], test$response)

performance(knn.pred, "auc")@y.values
plot(performance(knn.pred,"tpr","fpr"),colorize=TRUE)


# 6
performance(lda.pred, "auc")@y.values       # 0.8095238
performance(qda.pred, "auc")@y.values       # 0.7472619
performance(naive.pred, "auc")@y.values     # 0.8109524
performance(logistic.pred, "auc")@y.values  # 0.8225
performance(knn.pred, "auc")@y.values       # 0.58

# As we can see logistic regression shows the best performance
# And the worst one is the KNN in terms of area under the curve


# 7
logistic.pred=predict(logistic.fit, test)
logistic.pred = predict(logistic.fit, test, type = "response")

confusionMatrix(data = as.factor(as.numeric(logistic.pred>0.5) + 1), 
                reference = test$response, 
                positive = '2')
# Accuracy : 0.76
# Balanced Accuracy : 0.7000
# Sensitivity : 0.5500
# Specificity : 0.8500
# Precision: 0.61 (33 / (21+33))
