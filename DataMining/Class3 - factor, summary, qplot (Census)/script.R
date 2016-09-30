data <- read.csv( 'Census R.csv' )

data$sex <- factor( data$sex, 
                    levels = c( 1, 2 ), 
                    labels = c( 'Male', 'Female' ) )

barplot( table( data$sex ), 
         ylab = "Number", 
         main = "Title", 
         xlab = "X axes",
         legend.text = c( 'Male', 'Female' ) )

?barplot

str( mtcars )

View( mtcars )

plot( mtcars$mpg, 
      mtcars$hp,
      xlab = "Miles per galon",
      ylab = "Horse power" )


hist( data$age, main = "Title", xlab = "Age" )


install.packages("magrittr")
library(magrittr)


rm( diamonds )
View( diamonds )

d <- diamonds
View( d )

set.seed( 1997 )
sampled <- diamonds[ sample( nrow(diamonds), 400 ), ]
View( sampled )

qplot( log(carat), log(price), data=sampled, colour=clarity )
qplot( log(carat), log(price), data=sampled, shape=cut, colour=clarity )
qplot( log(carat), log(price), data=sampled, shape=clarity, colour=clarity )


qplot( color, price/carat, data=diamonds, colour=color, geom = 'jitter' )
qplot( color, data=diamonds, geom = 'bar' )

qplot( carat, data=diamonds, geom = 'histogram', binwidth = 0.1, xlim = c(0, 4) )
qplot( carat, data=diamonds, geom = 'density' )
qplot( carat, data=diamonds, fill=color, binwidth=0.1 )
qplot( carat, data=diamonds, geom = 'histogram', facets = color~. , xlim = c(0,4) )

str( College )
summary( College )
