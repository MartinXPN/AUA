library( neuralnet )

data(infert)
View( infert )

f <- formula( case ~ age + parity + induced + spontaneous )
set.seed( 2016 )
model <- neuralnet( f, data = infert, hidden = 2, linear.output = FALSE, err.fct = 'ce', rep = 4 )
summary( model )
plot( model )

set.seed( 2016 )
model <- neuralnet( f, data = infert, hidden = c(2,2), linear.output = FALSE, err.fct = 'ce', rep = 4 )
summary( model )
plot( model )
