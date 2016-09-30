# plot function 1/x
plot.function( func <- function(x) {
  return(1/x)
} )


head( mtcars, 10 ) # first 10 elements of mtcars
tail( mtcars, 10 ) # last 10 elements of mtcars
mtcars[2:10][2:4]  # take all rows in the range [2,10] and corresponding columns in the range [2,4]
mtcars['mpg']      # get data of mpg
mtcars$mpg         # get data of mpg

data(mtcars)
str(mtcars)     # xz
View(mtcars)    # show like excel sheet

dim(mtcars)     # shape of mtcars
nrow(mtcars)    # only number of rows
ncol(mtcars)    # only number of cols
dim(mtcars)[1]  # indexing in R starts with 1 not 0!

?col            # documentation for native stuff like <Column Indexes>
??something     # documentation for custom libraries (user defined)

n = c(2, 3, 5) 
s = c("aa", "bb", "cc") 
b = c(TRUE, FALSE, TRUE) 
df = data.frame(n, s, b)       # df is a data frame
df
