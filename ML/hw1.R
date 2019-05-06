library(ISLR)
library(ggplot2)
library(MASS)

## 8
df = Auto
df = na.omit(df)

# a) All the values are quantitative except origin and name
# b)
for (name in head(names(df), 7)) {
  print(c( name, range(df[, name])))
}

# c)
print(c('name', 'mean', 'std'))
for (name in head(names(df), 7)) {
  print(c( name, mean(df[, name]), sd(df[, name])))
}

# d, e)
plot(df$horsepower, df$mpg)
ggplot(data = df, aes(x=df$horsepower, y=df$mpg)) + geom_point() + geom_smooth(method='lm') + xlab('Horsepower') + ylab('Miles per gallon')
# As can be seen in the plot there is an obvious negative relationship
# between horsepower and miles per gallon with is very natural
# As cars with more horsepower consume more gas => cannot travel long distances 
# with few gallons of gas

plot(df$weight, df$mpg)
ggplot(data = df, aes(x=df$horsepower, y=df$mpg)) + geom_point() + geom_smooth(method='lm') + xlab('Weight') + ylab('Miles per gallon')
# As we can see in the graph, there is a negative relationship between miles per gallon and weight
# Obviously, Heavy cars consume more gas

plot(df$year, df$mpg)
ggplot(data = df, aes(x=df$year, y=df$mpg)) + geom_point() + geom_smooth(method='lm') + xlab('Year') + ylab('Miles per gallon')
# As we can see in the graph, cars improve over time and can travel more miles with less gas
# That can be connected to the fact that oil and gas were pretty expensive at that time
# And US was trying to catch up with low-consuming technologies of Japan

plot(df$year, df$horsepower)
ggplot(data = df, aes(x=df$year, y=df$horsepower)) + geom_point() + geom_smooth(method='lm') + xlab('Year') + ylab('Horsepower')
# As just mentioned, historically US tried to produce low-consumption cars


## 2
df = Boston
summary(df)
# The original data are 506 observations on 14 variables, medv being the target variable:
#   crim	per capita crime rate by town
# zn	proportion of residential land zoned for lots over 25,000 sq.ft
# indus	proportion of non-retail business acres per town
# chas	Charles River dummy variable (= 1 if tract bounds river; 0 otherwise)
# nox	nitric oxides concentration (parts per 10 million)
# rm	average number of rooms per dwelling
# age	proportion of owner-occupied units built prior to 1940
# dis	weighted distances to five Boston employment centres
# rad	index of accessibility to radial highways
# tax	full-value property-tax rate per USD 10,000
# ptratio	pupil-teacher ratio by town
# b	1000(B - 0.63)^2 where B is the proportion of blacks by town
# lstat	percentage of lower status of the population
# medv	median value of owner-occupied homes in USD 1000's

# b, c)
ggplot(data = df, aes(x=df$medv, y=df$age)) + geom_point() + geom_smooth(method='lm')

ggplot(data = df, aes(x=df$medv, y=df$crim)) + geom_point() + geom_smooth(method='lm')
ggplot(data = df, aes(x=df$age, y=df$crim)) + geom_point() + geom_smooth(method='lm')
ggplot(data = df, aes(x=df$b, y=df$crim)) + geom_point() + geom_smooth(method='lm')
ggplot(data = df, aes(x=df$ptratio, y=df$crim)) + geom_point() + geom_smooth(method='lm')

# As we can see there is some relationship in all the above plots with crime rate
# But most of them are not significant and some are just outliers

# For example ptratio and crime are correlated according to the plot, but the crime rate is
# only high for ptratio 21

# d)
ggplot(data = df, aes(x=df$b, y=df$crim)) + geom_point() + geom_smooth(method='lm')
# The more black people the less the crime rate (they can handle their problems internally)

ggplot(data = df, aes(x=df$ptratio, y=df$crim)) + geom_point() + geom_smooth(method='lm')
# I think there isn't enough evidence about the positive relationship between ptratio and the crime rate
# So the crime rate is only high when student/teacher rate is 21

for (name in names(df)) {
  print(c( name, range(df[, name])))
}
# "crim"    "0.00632" "88.9762" // dependent variable
# "zn"      "0"       "100"     proportion of residential land zoned for lots over 25,000 ranges from 0 to 100
# "indus"   "0.46"    "27.74"   proportion of non-retail business acres per town reaches at most 27% and there is at least 0.5% in each
# "chas"    "0"       "1"       either near the river or no
# "nox"     "0.385"   "0.871"   nitric oxides concentration reaches up to 0.87 (pretty high)
# "rm"      "3.561"   "8.78"    average number of rooms per dwelling, some have large number of rooms (averate 8.8)
# "age"     "2.9"     "100"     feasible age range for crime rate prediction
# "dis"     "1.1296"  "12.1265" weighted distances to five Boston employment centres
# "rad"     "1"       "24"      index of accessibility to radial highways
# "tax"     "187"     "711"     full-value property-tax rate per USD 10,000
# "ptratio" "12.6"    "22"      pupil-teacher ratio by town; I think the rate in armenia is much higher
# "black"   "0.32"    "396.9"   proportion of blacks by town
# "lstat"   "1.73"    "37.97"   percentage of lower status of the population
# "medv"    "5"       "50"      median value of owner-occupied homes; pretty diverse for one city

# e)
nrow(df[df$chas == 1,])
