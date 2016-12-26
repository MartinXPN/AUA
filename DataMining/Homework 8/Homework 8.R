# The data frame voice contains information about
# the voices of females and males. It summarizes
# several measurements for voice and the label,
# indicating the gender of the 'owner' of the
# voice.  
# Do not forget to set the seed to 2016 for
# all the functions that need random activity.  

# 1. Load voice data. Create testing and training
# sets. 80% goes to train, the rest to test. (7)
library( caret )
voice <- read.csv( 'voice.csv' )
sub <- createDataPartition( voice$label, p = 0.8, list = FALSE )
train <- voice[ sub, ]
test <- voice[ -sub, ]
rm( sub )

# 2. Create svm model, try different types of
# kernels.  Which one is giving the highest
# accuracy? Hint: Look at the help of the svm
# function to see what types of kernels are
# avilable.(7)
library( e1071 )

model <- svm( label ~., data = train, kernel = 'polynomial' )
pred_prob = predict( model, newdata = test, probabilty=TRUE )
confusionMatrix( pred_prob, test$label ) # 0.9557

model <- svm( label ~., data = train, kernel = 'sigmoid' )
pred_prob = predict( model, newdata = test, probabilty=TRUE )
confusionMatrix( pred_prob, test$label ) # 0.8797

model <- svm( label ~., data = train, kernel = 'linear' )
pred_prob = predict( model, newdata = test, probabilty=TRUE )
confusionMatrix( pred_prob, test$label ) # 0.9873

model <- svm( label ~., data = train, kernel = 'radial' )
pred_prob = predict( model, newdata = test, probabilty=TRUE )
confusionMatrix( pred_prob, test$label ) # 0.9889


# 3. Take the type of the kernel that gives the
# highest accuracy and proceed with it. Plot the
# ROC taking female as the class of interest. (7)

#Radial gives the highest accuracy
library(ROCR)

model = svm( label~., data=train, kernel="radial", probability=TRUE )
pred = predict( model, newdata=test, probability=TRUE )
pred_test = prediction(attr(pred,"probabilities")[,1], test$label, label.ordering = c("female", "male")) 
perf = performance(pred_test, "tpr", "fpr")
plot(perf)


# 4. Using library caret, do cross validation and
# find the optimal value of cost. What is the value
# of accuracy while using that value of cost? Use the
# seed of 2016. (8)
library( kernlab )
set.seed( 2016 )
ctrl = trainControl( method = "repeatedcv", number = 20, repeats = 3 )
train = train( label~., data = train, method = "svmRadial", trControl = ctrl, tuneLenght = 100 )
train$bestTune
#        sigma C
# 3 0.05744507 1
svmModel = svm( label~., data=train, kernel="radial", probability=TRUE, cost=1 )
pred = predict(svmModel, newdata=test, probabilty=TRUE)
confusionMatrix(pred, test$label, positive = "female")
#Accuracy : 0.9873

# 5. Take any other classification method that we
# covered during the class.  Compare it to the svm
# model in terms of accuracy.  Which one does
# better? (7)
logisticModel <- glm( label~., data = train, family = 'binomial' )
predictions <- predict( logisticModel, newdata = test )
pr_label <- ifelse( predictions < 0.5, 'female', 'male' )
confusionMatrix( pr_label, test$label, positive = 'male' ) # 0.9826

# Diabetes dataset contains information about
# different characteristics of the patients, as well as
# if they are diagnosed with diabetes or not.

# 6. Load diabetes.csv into R. Create testing and
# training datasets. As usual, 80% goes to train,
# the rest to test.  The proportions of variable
# Class should be maintained.  Build the lda model
# on the training set. Report the accuracy of the
# model.  Use 1 as positive class for diabetes. (7)
rm( list = ls() )
library(caret)
library(e1071)
library(ROCR)
library(MASS)
diabets <- read.csv( 'Diabetes.csv' )
diabets$Class <- factor( diabets$Class )
sub <- createDataPartition( diabets$Class, p = 0.8, list = FALSE )
train <- diabets[ sub, ]
test <- diabets[ -sub, ]
rm( sub )
model = lda( Class~.,data = train )
pred = predict( model, newdata = test )
confusionMatrix(pred$class, test$Class, positive ='1') # 0.7516

# 7. Using any of the classification methods that
# we covered so far, make predictions for the
# Class. Is that method doing better in comparison
# with LDA in terms of accuracy? (7)
logisticModel <- glm( Class~., data = train, family = 'binomial' )
predictions <- predict( logisticModel, newdata = test )
pr_label <- ifelse( predictions > 0.5, '1', '0' )
confusionMatrix( pr_label, test$Class, positive = '1' ) # 0.732
# No it's worse

# 8. Bonus 
# Find a dataset. Find something
# interesting related to that data.  Prepare
# predictive methods, do clustering, find
# interesting and meaningful patterns based on that
# data. Do not forget to upload that new data to moodle
# along with your submission. (10)
