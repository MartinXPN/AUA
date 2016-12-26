# The dataset Cancer.csv contains data about the tumor cells
# for 100 patients. The independent variables are different
# characteristics of the tumor cells. The dependant variable
# is diagosis_result, which has two classes: B and M (benign
# and malignant). Our goal is to create the model to identify
# whether the patient has type B or type M cancer.

# 1. Load data. Prepare training and testing sets (80%/20%).
# Make all the required preprocessing for building the
# neuralnetwork model. (10)

library( caret )
library( neuralnet )
library( ROCR )
cancer <- read.csv( 'Cancer.csv' )
cancer_scaled <- data.frame( as.data.frame( scale( cancer[,-9] ) ), 
                             diagnosis_result = cancer$diagnosis_result )

cancer_scaled$diagnosis_result <- as.numeric( factor( cancer_scaled$diagnosis_result, 
                                                      levels = c( 'M', 'B' ), 
                                                      labels = c( 1, 0 ) ) )
sub <- createDataPartition( cancer$diagnosis_result, p = 0.8, list = FALSE )
train <- cancer_scaled[sub,]
test <- cancer_scaled[-sub,]
rm( sub )

# 2. Build the neural network model. Play with the parameters
# in order to get as high accuracy as possible. Report the
# final accuracy. Plot the model, make sure you do not have
# overlapping objects in the plot.  (20)
fm <- formula(diagnosis_result ~ radius+texture+perimeter+area+smoothness+compactness+symmetry+fractal_dimension, data = train) 
model <- neuralnet( formula = fm, 
                    data = train,
                    hidden = c( 5, 3 ),
                    linear.output = F,
                    rep = 4 )

plot( model, length = 0.1 )
res <- compute( model, test[,-9], rep = 1 )
p_test <- prediction( res$net.result[,1], test$diagnosis_result )
performance( p_test, "auc" )@y.values # 0.9285714286

# 3. Use one of the classification model that we covered so
# far. Cross validate it using caret. Out of the two 'cross
# validated' models, which one is doing better? (20)

library(class)
cancer <- read.csv( 'Cancer.csv' )
sub <- createDataPartition( cancer$diagnosis_result, p = 0.8, list = FALSE )
train <- cancer[sub,]
test <- cancer[-sub,]
rm( sub )
ctrl <- trainControl(method = "repeatedcv",
                     number = 12,
                     repeats = 3,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary) 
knnFit <- train(diagnosis_result ~ ., 
                data = train, 
                method = "knn",
                trControl = ctrl,
                preProcess = c("center","scale"),
                tuneGrid = expand.grid(k=3:15) )

knnFit$results # => k = 12
knnModel <- knn( train[,-9],
                 test[,-9],
                 train$diagnosis_result,
                 k = 12,
                 prob = TRUE )
pred <- predict( knnFit, newdata = test, type = 'prob' )
p_test <- prediction( pred[,2], test$diagnosis_result )
performance( p_test, 'auc' )@y.values # 0.8154761905
# => neural network is much better

# BONUS Find data with at least one catrgorical independent
# variable and build a neural network on it. What are the
# AUC, accuracy, sensitivity and specificity of your model?
# Explain their meanings.  (10)
