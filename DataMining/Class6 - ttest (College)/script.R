load( 'College.rda' )

View( College )

# 1. numberic var ~ 2. categoric var
t.test( College$Apps ~ College$Private )      # 2.5 times difference
t.test( College$Enroll ~ College$Private )    # 4 times difference
t.test( College$Personal ~ College$Private )  # no difference

data <- read.csv( 'Titanic_imputed.csv' )
View( data )

data$pclass <- factor( data$pclass, labels = c( "rich", 'normal', 'poor' ), levels = c( 1, 2, 3 ) )
data$survived <- factor( data$survived, labels = c( 'yes', 'no' ), levels = c( 1, 0) )
View( data )


Table <- table( data$survived, data$pclass )  # create table with 2 values (survived, pclass)
Table                                         # show the table
chisq.test( Table )                           # k square test

TableGender <- table( data$survived, data$sex ) # create table with 2 values (survived, pclass)
TableGender                                     # show the table
chisq.test( TableGender )                       # k square test





# BLOOD ANALYSIS
blood <- read.table( 'blood pressure.txt', header = TRUE )
View( blood )
blood$Index <- NULL
blood$One <- NULL


# plot the relationship between age and pressure
library(ggplot2)
qplot( blood$Age, blood$Pressure )

model <- lm( Pressure~Age, data = blood )
summary( model )
# => Pressure = 0.97*Age + 98.7
qplot( blood$Age, blood$Pressure ) + geom_abline( slope = 0.97, intercept = 98.7 )



# create new dataset without outliers
blood <- blood[ -c( which.max(blood$Pressure) ), ]
model <- lm( Pressure~Age, data = blood )
summary( model )
# => Pressure = 0.9493*Age + 97.0771
qplot( blood$Age, blood$Pressure ) + geom_abline( slope = 0.9493, intercept = 97.0771 )
names( model )
dist <- data.frame( model$residuals )
colnames( dist ) <- c( 'val' )

outliers <- data.frame( dist[ (abs(dist$val) > 10), ] )
colnames( outliers ) <- c( 'val' )

a <- model[ ( abs(dist$val) < 10),]

model$residuals
qplot( model$residuals )
View( outliers )