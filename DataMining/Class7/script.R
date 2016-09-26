abalone <- read.csv( 'Abalone.csv' )
View( abalone )

boxplot(rings~sex, data=abalone )          # we can see that there is no big difference between M and F
abalone$sex <- as.character( abalone$sex ) # thats why we decide to merge them and call NI (not infant)
abalone$sex

abalone$sex [ abalone$sex != 'I' ] <- 'NI' # subset M and F with NI
abalone$sex                                # see result
boxplot(rings~sex, data=abalone )


abalone$sex <- as.factor( abalone$sex )    # make sex a factor variable
abalone$sex                                # see results

cor( abalone[,-c(1)] )  # correlation between every element in abalone except the sex (as it is not numeric)


model <- lm( rings~., data = abalone )         # linear model. rings is the independent variable
summary( model )

model2 <- lm( rings~. - length, data = abalone) # exclude length
summary( model2 )

set.seed( 1997 )
sub <- sample( nrow( abalone ), floor( nrow( abalone ) * 0.7 ) ) # geenrate nrow( abalone )*0.7 integers that rage from 1 to nrow( abalone )

train <- abalone[ sub,]   # use the generated rows as a train data i.e 70% of the whole data
test <- abalone[ -sub, ]  # use the rest of the data as a test

setToBeRemoved <- c(1, 2, 3, 4, 5, 6, 7) # remove highly correlated (to each other not to rings) variabes
subTrain <- train[ -setToBeRemoved ]     # construct a new set for training that doesn't include the highly correlated variables
subTest <- test[ -setToBeRemoved ]       # construct a new set for testing that doesn't include the highly correlated variables

lm( rings~. , data = subTrain )
lm( rings~. , data = subTest )

Model1 <- lm( rings ~ sex + height + weight.w, data = train )
Model2 <- lm( rings ~ height + weight.w, data = train )
Model3 <- lm( rings ~ sex + weight.w, data = train )
Model


library( memisc )
mtable( Model1, Model2, Model3 ) # compare models


baseline <- sqrt( mean( ( mean(test$rings) - mean(train$rings) )^2 ) )
baseline
