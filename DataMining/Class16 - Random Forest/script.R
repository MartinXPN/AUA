pml <- read.csv('pml.csv')
library(caret)
set.seed(2016)
trainindeces <- createDataPartition(pml$classe, p = 0.8, list = FALSE)
train <- pml[trainindeces,]
test <- pml[-trainindeces,]
rm(trainindeces)

library( randomForest )
model <- randomForest(classe~., data = train, ntree = 50 )
names( model )
model$err.rate
plot( model )
# write.csv(col.names = false) to remove indices

varImp()

datas <- read.csv('Diabetes.csv')
datas$Class <- factor( datas$Class )
set.seed(2016)
trainindeces <- createDataPartition(datas$Class, p = 0.8, list = FALSE)
train <- datas[trainindeces,]
test <- datas[-trainindeces,]
rm(trainindeces)
model <- randomForest(Class~., data = train, ntree = 50 )
names( model )
model$err.rate
plot( model )
??randomForest
varImp(model)
model <- randomForest(Class~., data = train, do.trace = TRUE, importance = TRUE, ntree = 500, mtry = 5, maxnodes = 15, nodesize = 60)
ctrl <- trainControl(method = 'cv', number = 10, summaryFunction = twoClassSummary, classProbs = TRUE)
grid <- expand.grid(mtry = c(3, 4, 5, 6, 7))
fit <- train(Class ~., data = train, method = 'rf', trControl = ctrl, tuneGrid = grid, metric = 'ROC')
names(fit)
fit$metric
plot(fit)
