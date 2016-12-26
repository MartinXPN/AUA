# Running the whole file may take several hours..

##XGBOOST model
brary(caret)
library( ROCR )

# load data
trainData <- read.csv( "train_A.csv" )
trainData$race <- as.numeric(trainData$race)
trainData$gender <- as.numeric(trainData$gender)
trainData$max_glu_serum <- as.numeric(trainData$max_glu_serum)
trainData$metformin <- as.numeric(trainData$metformin)
trainData$A1Cresult <- as.numeric(trainData$A1Cresult)
trainData$glimepiride <- as.numeric(trainData$glimepiride)
trainData$glipizide <- as.numeric(trainData$glipizide)
trainData$glyburide <- as.numeric(trainData$glyburide)
trainData$pioglitazone <- as.numeric(trainData$pioglitazone)
trainData$rosiglitazone <- as.numeric(trainData$rosiglitazone)
trainData$insulin <- as.numeric(trainData$insulin)
trainData$change <- as.numeric(trainData$change)
trainData$diabetesMed <- as.numeric(trainData$diabetesMed)
trainData$disch_disp_modified <- as.numeric(trainData$disch_disp_modified)
trainData$adm_src_mod <- as.numeric(trainData$adm_src_mod)
trainData$adm_typ_mod <- as.numeric(trainData$adm_typ_mod)
trainData$age_mod <- as.numeric(trainData$age_mod)
trainData$diag1_mod <- as.numeric(trainData$diag1_mod)
trainData$diag2_mod <- as.numeric(trainData$diag2_mod)
trainData$diag3_mod <- as.numeric(trainData$diag3_mod)
trainData_Class <- ifelse(as.numeric(factor(trainData$Class, levels = c('YES', 'NO'), labels = c(1,0)))==1, 1, 0)
trainData$Class <- NULL

testData <- read.csv( 'test_A.csv' )
testData$race <- as.numeric(testData$race)
testData$gender <- as.numeric(testData$gender)
testData$max_glu_serum <- as.numeric(testData$max_glu_serum)
testData$metformin <- as.numeric(testData$metformin)
testData$A1Cresult <- as.numeric(testData$A1Cresult)
testData$glimepiride <- as.numeric(testData$glimepiride)
testData$glipizide <- as.numeric(testData$glipizide)
testData$glyburide <- as.numeric(testData$glyburide)
testData$pioglitazone <- as.numeric(testData$pioglitazone)
testData$rosiglitazone <- as.numeric(testData$rosiglitazone)
testData$insulin <- as.numeric(testData$insulin)
testData$change <- as.numeric(testData$change)
testData$diabetesMed <- as.numeric(testData$diabetesMed)
testData$disch_disp_modified <- as.numeric(testData$disch_disp_modified)
testData$adm_src_mod <- as.numeric(testData$adm_src_mod)
testData$adm_typ_mod <- as.numeric(testData$adm_typ_mod)
testData$age_mod <- as.numeric(testData$age_mod)
testData$diag1_mod <- as.numeric(testData$diag1_mod)
testData$diag2_mod <- as.numeric(testData$diag2_mod)
testData$diag3_mod <- as.numeric(testData$diag3_mod)


# Scale variables
trainData <- as.data.frame( scale( trainData ) )
testData <- as.data.frame( scale( testData[,-1] ) )

set.seed(2016)
train_indeces <- createDataPartition(trainData_Class, p = 0.8, list = F)
train <- trainData[train_indeces,]
test <- trainData[-train_indeces,]
train_Class <- trainData_Class[train_indeces]
test_Class <- trainData_Class[-train_indeces]

require( xgboost )
dtrain <- xgb.DMatrix(data = as.matrix( train ), label=train_Class)
dtest <- xgb.DMatrix(data = as.matrix( test ), label=test_Class)
watchlist <- list(train=dtrain, test=dtest)

bst <- xgb.train(data=dtrain, 
                 max.depth=4, 
                 #booster = "gblinear", -> this one gets worse results
                 eta=0.03, 
                 nthread = 5, 
                 nround=900, 
                 eval.metric = "logloss",
                 watchlist=watchlist, 
                 objective = "binary:logitraw") 
# 0.6922286 with max.depth = 5, eta = 0.02, nthread = 4, nround = 800
# 0.6920942 with max.depth = 5, eta = 0.05, nthread = 10, nround = 800
# 0.6932212 with max.depth = 5, eta = 0.03, nthread = 4, nround = 800
# 0.6941874 with max.depth = 4, eta = 0.03, nthread = 5, nround = 900, binary:logitraw

# get AUC
res <- prediction( predict(bst, as.matrix( test ) ), test_Class )
performance( res, 'auc' )@y.values


validationLabels <- predict(bst, as.matrix( testData ), type = 'response')
write.csv( validationLabels, file = 'xgboost.csv', row.names = T )



##KSVM model
rm( list = ls() )
library( kernlab )
library( ROCR )
library( caret )


# load data
data <- read.csv( "train_A.csv" )
validationData <- read.csv( 'test_A.csv' )
validationData$ID <- NULL


sub <- createDataPartition( data$Class, p = 0.8, list = FALSE ) # Too long on the whole data, that's why better take some part of it
train <- data[ sub, ]
test <- data[-sub, ]
rm( sub )
model <- ksvm(Class~.,data=train, type="C-svc",kernel="rbfdot",kpar="automatic",prob.model=TRUE,cache=500 )
# more cache => faster performance

# get AUC
probabilities <- predict( model, newdata = test, type = 'prob' )
res <- prediction( probs, test$Class )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform )
performance( res, 'auc' )@y.values # 0.6899727


# Save result to file
validationLabels <- predict(model, newdata = validationData, type = 'prob' )
write.csv( validationLabels[,2], file = 'ksvm.csv', row.names = TRUE )


##Random Forest
rm( list = ls() )
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




##gradient boosting model
rm( list = ls() )
# load data
data <- read.csv( 'train_A.csv' )
submit <- read.csv( 'test_A.csv' )
submit$ID <- NULL
data$Class <- factor( data$Class, levels = c( 'YES', 'NO' ), labels = c( 1, 0 ) )

library( caret )
sub <- createDataPartition( data$Class, p = 0.9, list = FALSE )
train <- data[ sub, ]
test <- data[ -sub, ]
rm( sub )


library( gbm )
??gbm
model <- gbm(Class ~.,               # formula
             data=train,              # dataset
             distribution="multinomial", # see the help for other choices
             n.trees=500,             # number of trees
             shrinkage=0.03,          # shrinkage or learning rate, 0.001 to 0.1 usually work
             interaction.depth=3,     # 1: additive model, 2: two-way interactions, etc.
             train.fraction = 0.8,    # fraction of data for training,
             n.minobsinnode = 10,     # minimum total weight needed in each node
             cv.folds = 5,            # do 3-fold cross-validation
             keep.data=FALSE,         # keep a copy of the dataset with the object
             verbose=TRUE,            # print out progress
             n.cores=3                # use only 3 cores
)

# calculate best number of trees
best.iter <- gbm.perf( model, method="OOB" )
best.iter

best.iter <- gbm.perf( model, method="test" )
best.iter

# Get AUC score
library( ROCR )
prediction_probabilities <- predict( model, newdata = test, n.trees = best.iter, type = 'response' )
res <- prediction( prediction_probabilities[,1,1], test$Class )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform, colorize = TRUE )
performance( res, 'auc' )@y.values # 0.6890673(167)


# get predictions
predictions <- predict( model, newdata = submit, n.trees = 500, type = 'response' )
write.csv( predictions[,1,1], file = 'gbm_500.csv', row.names = T )







# Make a vote for the best result
# Mix 4 models
# if 3 models out of 4 are confident that the result is 0/1 => we'll print 0/1 instead of the avarage
# in other cases we'll pring the avarage of the 4 models
rm( list = ls() )
pred1 <- read.csv('gbm_500.csv')
pred2 <- read.csv('ksvm.csv')
pred3 <- read.csv('RF_sub.csv')
pred4 <- read.csv('xgboost.csv')
pred_prob_1 <- pred1$Class
pred_prob_2 <- pred2$Class
pred_prob_3 <- pred3$Class
pred_prob_4 <- pred4$Class

pred_prob_average <- (pred_prob_1 + pred_prob_2 + pred_prob_3 + pred_prob_4) / 4

num_0 <- pred_prob_1*0
num_0 <- ifelse(pred_prob_1 < 0.2, 1, 0) + 
  ifelse(pred_prob_2 < 0.2, 1, 0) + 
  ifelse(pred_prob_3 < 0.2, 1, 0) + 
  ifelse(pred_prob_4 < 0.2, 1, 0) 
num_1 <- ifelse(pred_prob_1 > 0.8, 1, 0) + 
  ifelse(pred_prob_2 > 0.8, 1, 0) + 
  ifelse(pred_prob_3 > 0.8, 1, 0) + 
  ifelse(pred_prob_4 > 0.8, 1, 0) 

pred_prob_final <- pred_prob_average
for( i in c( 1 : length( pred_prob_average ) ) ) {
  if(num_1[i] >= 3) {
    pred_prob_final[i] <- 1
  } 
  else if(pred_prob_average[i] > 0.85) {
    pred_prob_final[i] <- 1
  } 
  else if(num_0[i] >= 3) {
    pred_prob_final[i] <- 0
  }
  else if(pred_prob_average[i] < 0.15) {
    pred_prob_final[i] <- 0
  }
}

write.csv(pred_prob_final, 'mix_all.csv', row.names = T)
