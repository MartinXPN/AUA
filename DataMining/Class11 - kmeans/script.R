# Small example

#shitty code. even my son can write better. See me after the class. - Madoyan
data <- read.csv( 'KNN small example.csv' )

# Make dependent variable factor (Yes/No) instead of (1/0)
data$Default <- factor( data$Default, levels = c( 0, 1 ), labels = c( 'No', 'Yes' ) )

library( ggplot2 )
qplot( data$Age, data$Loan, colour = data$Default ) # plot the data as scatter
# red -> No   blue -> Yes


new_case <- c( 30, 130000, NA ) # create a new variable that will be inserted to the data
data <- rbind( data, new_case ) # bind variable to the data frame
rm( list = ls() )


#Diabets
diabets <- read.csv( 'Diabetes.csv' )
diabets_scaled <- as.data.frame( scale( diabets[,1:8] ) )                                      # scale the variables
diabets_scaled$class <- factor( diabets$Class, levels = c( 0, 1 ), labels = c( 'No', 'Yes' ) ) # factor the deptendent variable

library( caret )
library( caTools )
set.seed( 1997 )
trainIndex <- createDataPartition(diabets_scaled$class, p = .8, list = FALSE)
train <- diabets_scaled[trainIndex,]
test <- diabets_scaled[-trainIndex,]
getwd()

library( class )
model <- knn( train[,-9], test[,-9], train$class, k = 8 )
confusionMatrix( model, test$class, positive = 'Yes' )




library( ggplot2 )
diabets <- read.csv( 'Diabetes.csv' )
control <- trainControl( "repeatedcv", number = 10, repeats = 3 )
diabets$Class <- factor( diabets$Class, levels = c( 0, 1 ), labels = c( 'No', 'Yes' ) )

knn <- train( Class~., 
              data = diabets, 
              trcontrol = control, 
              preProcess = c( 'center', 'scale' ), 
              method = 'knn', 
              tuneLength = 20 )
plot( knn )
