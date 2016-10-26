library( rpart)
install.packages( 'rattle')
library( rpart.plot )
library( rattle )
library( lattice )
library( ggplot2 )
library( caret )
library( ROCR )

titanic <- read.csv( 'Titanic_imputed.csv' )
titanic$survived <- factor( titanic$survived, levels = c(0,1), labels = c('No', 'Yes') )
titanic$pclass <- as.factor( titanic$pclass )

sub <- createDataPartition( titanic$survived, p = 0.75, list = FALSE ) # survived is dependent variable
train <- titanic[ sub, ]                                               # create train set
test <- titanic[ -sub, ]                                               # create test set
rm( sub )


model <- rpart( titanic$survived ~ titanic$sex, method = 'class' )  # create a decision tree
# method = 'class' indicates that we wanna predict classes not continious variables
prp( model, type = 1, extra = 1, faclen = 8, main = "" )            # create plot for the decision tree
# type -> changes the design of a tree
# faclen -> length of a printed label




model <- rpart( survived ~ 
                  sex + 
                  age + 
                  sibsp + 
                  parch + 
                  pclass, data = train, method = 'class' )
prp( model )              # ugly plot
fancyRpartPlot( model )   # nicer plot
summary( model )
asRules( model )


################################################################################
rm( list = ls() )
weather <- read.csv( 'weather.csv' )
sub <- createDataPartition( weather$RainTomorrow, p = 0.75, list = FALSE )
train <- weather[ sub, ]   # create train set
test <- weather[ -sub, ]   # create test set
rm( sub )

model <- rpart( RainTomorrow ~ .-Rainfall, data = train, method = 'class' )
prp( model )
fancyRpartPlot( model )
