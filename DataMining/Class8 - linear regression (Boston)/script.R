boston <- read.csv( 'Boston.csv' )
View( boston )

# dependent variable is MEDV
cor( boston[ -c(4) ] )
library( ggplot2 )
qplot( log(DIS), MEDV, data = boston )
qplot( log(CRIM), MEDV, data = boston )  # not informative enough
qplot( ZN, MEDV, data = boston )         # nothing
qplot( INDUS, MEDV, data = boston )      # nothing
qplot( NOX, MEDV, data = boston )        # nothing
qplot( RM, MEDV, data = boston )         # okayish y = kx
qplot( AGE, MEDV, data = boston )        # nothing
qplot( sqrt(DIS), MEDV, data = boston )  # not so informative
qplot( RAD, MEDV, data = boston )        # nothing
qplot( TAX, MEDV, data = boston )        # nothing
qplot( PTRATIO, MEDV, data = boston )    # nothing
qplot( B, MEDV, data = boston )          # nothing
qplot( LSTAT^(1/2), MEDV, data = boston )
qplot( LSTAT, RM^2, data = boston )

cor( (boston$LSTAT)^(1/2), boston$MEDV )
cor( 1/(boston$LSTAT), boston$MEDV )
cor( 1/(boston$LSTAT)^(1/4), boston$MEDV )
cor( 1/log(boston$LSTAT), boston$MEDV )
cor( log(boston$LSTAT), sqrt(boston$MEDV) )

qplot( log(boston$LSTAT), sqrt(boston$MEDV) )
qplot( 1/(boston$LSTAT)^(1/4), sqrt(boston$MEDV) )

boston$LSTAT <- 1/(boston$LSTAT)^(1/4)

# create train and test datasets
set.seed( 1997 )
sub <- sample( nrow( boston ), floor( nrow( boston ) * 0.7 ) ) # geenrate nrow( abalone )*0.7 integers that rage from 1 to nrow( abalone )
train <- boston[ sub,]                                         # use the generated rows as a train data i.e 70% of the whole data
test <- boston[ -sub, ]                                        # use the rest of the data as a test

# build a model
bostonModel1 <- lm( MEDV ~ LSTAT + RM, data = train )  # linear model that takes into account LSTAT and RM
bostonModel2 <- lm( MEDV ~ LSTAT, data = train )       # linear model that takes into account LSTAT
bostonModel3 <- lm( MEDV ~ DIS + RM, data = train )    # linear model that takes into account DIS and RM

predictions1 <- predict( bostonModel1, newdata = test )  # make predictins on test dataset
predictions2 <- predict( bostonModel2, newdata = test )  # make predictins on test dataset
predictions3 <- predict( bostonModel3, newdata = test )  # make predictins on test dataset

sqrt( mean( ( test$MEDV - predictions1 )^2 ) )  # calculate the error for bostonModel1
sqrt( mean( ( test$MEDV - predictions2 )^2 ) )  # calculate the error for bostonModel2
sqrt( mean( ( test$MEDV - predictions3 )^2 ) )  # calculate the error for bostonModel3


# consider all 2^n different models and choose the best one
library(MASS)
model <- lm( MEDV ~.-LSTAT, data = train )   # include all the variables except LSTAT
step <- stepAIC( model, direction = 'both' ) # consider these models

step$anova # it suggests that taking everything except INDUS is the best model
