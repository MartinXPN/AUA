library(randomForest)
library(caret)
library(ROCR)
#for multithreading
library(parallel) 
library(doParallel)

train<- read.csv("train_A.csv")
test<- read.csv("test_A.csv")


set.seed(2016)
ind<- createDataPartition(train$Class, p = 0.8, list = F)
train_p<-train[ind,]
test_p<-train[-ind,]


#multithreading the cross validation
cluster <- makeCluster(detectCores() - 1) # convention to leave 1 core for OS
registerDoParallel(cluster)

set.seed(2016)
ctrl<- trainControl(method = "repeatedcv", 
                    number = 10, repeats =  3, 
                    classProbs = T, allowParallel = T)

fit<-train(Class~., data= train_p, method="rf",
           trControl=ctrl, tuneGrid = expand.grid(mtry = 5:15),
           metric="ROC")
fit

set.seed(2016)
model<-randomForest(Class~., data = train_p, do.trace = T,
                    mtry=5, ntree =2000,
                    imporatance=T,  
                    maxnodes = 66,
                    nodesize= 88) 

model
pr<- predict(model, newdata = test_p, type= "prob")
pr

pred<- ifelse(pr[,2] > 0.5, "YES" , "NO")
confusionMatrix(pred, test_p$Class, positive = "YES")

#ROC curve
pred1 <- prediction(pr[,2], test_p$Class) 
perf <- performance(pred1,"tpr","fpr")
performance(pred1, "auc")@y.values
plot(perf)

#predicting for test dataset
pr_test<- predict(model, newdata = test, type = "prob" )
test$Class<-pr_test[,2]
RF_sub<-as.data.frame(test[,c(1, ncol(test))])

write.csv(RF_sub, file = "RF_sub.csv", row.names = F)
