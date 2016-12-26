setwd( '/home/martin/Desktop/Projects/DataMining/R/')
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
