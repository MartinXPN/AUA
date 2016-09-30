#Getting working directory
data(mtcars)
str(mtcars)
dim(mtcars)[2]
nrow(mtcars)
ncol(mtcars)
View(mtcars)
head(mtcars,n=5)
tail(mtcars,n=5)
mtcars[5:10,1:3]
mtcars[,1]
mtcars[,"mpg"]
mtcars$mpg
