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

install.packages('xgboost')
require( xgboost )
dtrain <- xgb.DMatrix(data = as.matrix( train ), label=train_Class)
dtest <- xgb.DMatrix(data = as.matrix( test ), label=test_Class)
watchlist <- list(train=dtrain, test=dtest)

bst <- xgb.train(data=dtrain, 
                 max.depth=4, 
                 #booster = "gblinear",
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
write.csv( validationLabels, file = 'predictions.csv', row.names = T )
