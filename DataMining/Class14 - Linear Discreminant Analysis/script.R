data( iris )
View( iris )
plot( iris )

iris_subsampled <- subset( iris, subset = ( iris$Species != 'virginica' ) )
iris_subsampled$Species <- factor( iris_subsampled$Species )

library( ggplot2 )
qplot( iris_subsampled$Sepal.Width, iris_subsampled$Sepal.Length, colour = iris_subsampled$Species ) + 
  geom_abline( intercept = 2.8, slope = 0.8 )

versicolor <- subset( iris, subset = ( iris$Species == 'versicolor' ) )


# Discriminant analysis
library( MASS )
model <- lda( Species ~., data = iris )
model

predictions <- predict( model )
predictions
table( predictions$class, iris$Species )


# plot predictions
# x = LD1 y = LD2
# LD1 is much more important than LD2
qplot( predictions$x[, 1], predictions$x[, 2], colour = iris$Species )

# vector of data        class labels
ldahist( predictions$x[ , 1 ], iris$Species ) # good division
ldahist( predictions$x[ , 2 ], iris$Species ) # messy stuff


library( klaR )
# tries all possible combinations of independent variables
partimat( Species~., data = iris, method = 'lda' )
