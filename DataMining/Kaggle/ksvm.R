rm( list = ls() )
library( kernlab )
library( ROCR )
library( caret )


# load data
data <- read.csv( "train_A.csv" )
validationData <- read.csv( 'test_A.csv' )
validationData$ID <- NULL


sub <- createDataPartition( data$Class, p = 0.7, list = FALSE )
train <- data[ sub, ]
test <- data[-sub, ]
rm( sub )
model <- ksvm(Class~.,data=train, type="C-svc",kernel="rbfdot",kpar="automatic",prob.model=TRUE,cache=500 )


# get AUC
probabilities <- predict( model, newdata = test, type = 'prob' )
res <- prediction( probs, test$Class )
perform <- performance( res, 'tpr', 'fpr' )
plot( perform )
performance( res, 'auc' )@y.values # 0.6899727



# Save result to file
validationLabels <- predict(model, newdata = validationData, type = 'prob' )
write.csv( validationLabels[,2], file = 'ksvm.csv', row.names = TRUE )
