# Logistic regression
titanic <- read.csv( 'Titanic_imputed.csv' )
titanic$survived <- factor( titanic$survived, levels = c(0,1), labels = c('No', 'Yes') )
model <- glm( survived~sex, data = titanic, family = 'binomial' )  # logistic regression model for variable survived


summary( model )                      
exp( model$coefficients )             # intercept = 2.66929134    slope = 0.08843935


table( titanic$survived, titanic$sex )

161 / ( 161 + 682 ) # probability of males to be survived
339 / ( 339 + 127 ) # probability of females to be survived


# Positive / Negative outcomes
# TruePositive                  FalsePositive
# FalseNegative                 TrueNegative

# True = model predicted correctly
# False = model failed
# Negative = answer was negative
# Positive = answer was positive


# Accuracy = ( TruePositive + TrueNegative ) / ALL
# Sensitivity = TruePositive / ( TruePositive + TrueNegative )  => P(TruePositive | Positive)
# Specificity = TrueNegative / ( TruePositive + TrueNegative )  => P(TrueNegative | Positive)



library( 'caret' )
set.seed( 1982 )
sub <- createDataPartition( titanic$survived, p = 0.75, list = FALSE ) # survived is dependent variable
train <- titanic[ sub, ]                                               # create train set
test <- titanic[ -sub, ]                                               # create test set
rm( sub )


# create logistic regression model
model <- glm( survived~sex+pclass+age+sibsp+parch, data = train, family = 'binomial' )
summary( model )

# remove parch from the model as it's not that significant
model <- glm( survived~sex+pclass+age+sibsp, data = train, family = 'binomial' )
summary( model )

predictions <- predict( model, newdata = test, type = 'response' )
summary( predictions )

table( predictions > 0.5, test$survived ) # confusion matrix
pr_label <- ifelse( predictions > 0.5, 'Yes', 'No' )
confusionMatrix( pr_label, test$survived, positive = 'Yes' ) # get all parameters -> sensitivity, specificity, accuracy...

library( 'ROCR')
ptest <- prediction( predictions, test$survived )
perform <- performance( ptest, 'tpr', 'fpr' )
plot( perform )
