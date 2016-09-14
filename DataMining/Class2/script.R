# ctrl+L to clear console
a <- c( 1, 2, 3 )   # c() means combine
a
x <- 1
rm( x ) # remove x from kernel
x       # error x is not in kernel


mean(x = c( 1, 2, 3, 4) )
x                            # error x is not in kernel

mean(x <- c( 1, 2, 3, 4) )   # creates an object x
x                            # x is in kernel



df <- mtcars[,c(1:3, 7)]
View(df)
names( df )

vec = c( "mpg", "hp", "cyl" )
new_df <- mtcars[ vec ]
new_df


min( mtcars$mpg )        # returns minimum value from the column mpg
which.min( mtcars$mpg )  # returns the number of the row of the column mpg


max( mtcars$hp )        # returns minimum value from the column mpg
which.max( mtcars$hp )  # returns the number of the row of the column mpg

row <- which.max( mtcars$wt )
row
rownames( mtcars )[row]



rownames( mtcars )[ which.max( mtcars$wt ) ]



blya <- c( 1:25, 77 )
blya
mean( blya )
median( blya )
sd( blya )


a <- range( blya )     # min and max of blya
b = a[2] - a[1]        # get difference of min and max
b


summary( mtcars )      # min, max, 1st quartile, 3rd quartile...




data <- read.csv( 'Census R.csv' )
View( data )

data$sex <- factor( data$sex, levels = c( 1, 2 ), labels = c( 'Male', 'Female' ) )
data$happy <- ordered( data$happy, 
                       levels = c( 1, 2, 3 ), 
                       labels = c( 'Very happy', 'Pretty happy', 'Not too happy' ), 
                       exclude = c( 8, 9 ) )
data$age[ data$age == 99 ] <- NA    # put NA for all cells that have value 99
data$age[ data$age == 98 ] <- NA    # put NA for all cells that have value 98
mean( data$age, na.rm = TRUE )      # get mean of age exclude NAs
sd( data$age, na.rm = TRUE )        # get standart deviation exclude NAs
median( data$age, na.rm = TRUE )    # get median exclude NAs

new_data <- data[data$age > 34 || data$age < 19, ]
aggregate( data$age, 
           by = list( data$sex ), 
           FUN = 'mean', 
           na.rm = TRUE )
aggregate( data[, c( 'age', 'sibs') ], 
           by = list( data$sex, data$happy ), 
           FUN = 'mean', 
           na.rm = TRUE )

table( data$sex, data$happy )
blah <- table( data$sex, data$happy )
prop.table( blah )
prop.table( blah, 1 )


summary( new_data$age )
summary( data$age )

View( new_data )
View( data )
