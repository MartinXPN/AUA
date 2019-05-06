rm(list = ls())
require(carData)
require(glmnet)
library(GGally)
library(ggplot2)
df = UN
dim(df)  # 213 rows, 7 features
sapply(colnames(df), function(x) class(df[[x]]))
#  region           group       fertility           ppgdp        lifeExpF        pctUrban     infantMortality 
# "factor"        "factor"       "numeric"       "numeric"       "numeric"       "numeric"       "numeric" 

df = na.omit(df)
dim(df) # 193   7 => 20 rows removed

pairs(df)
ggpairs(df)
# df$pctUrban, df$infantMortality, df$fertility have pretty high
# correlation with df$lifeExpF we can check that later with cor()
# But for now I only judge by the plots we just obtained through ggpairs

# Lets take region as a choice for our categorical variable
summary(df$region)
# Africa          Asia     Caribbean        Europe    Latin Amer North America NorthAtlantic       Oceania 
# 52            50            13            39            20             2             0            17 

length(levels(df$region)) # 8 levels
ggplot(df, aes(x=region, y=lifeExpF, fill=region)) + geom_boxplot()
# Yes, as we can see life expectency is pretty low in Africa and very high in America


# Lets pick pctUrban as our numeric variable
summary(df$pctUrban)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  11.0    39.0    59.0    57.1    75.0   100.0 

# 1st Qu: 39
# 3rd Qu: 75
ggplot(data = df, aes(x=df$infantMortality, y=df$lifeExpF)) + geom_point() + 
  geom_smooth(method='lm') + 
  ggtitle('I know how to set a title! Yeah!') + xlab('infantMortality') + ylab('Life expectancy')
# Pretty much linear relationship
# One may claim that it's not but I guess there isn't enough evidence to reject the hypothesis that
# The relationship is linear





# 2
model = lm(lifeExpF ~ ., data=df)
summary(model)
# Multiple R-squared:  0.9072,	Adjusted R-squared:  0.9016 
# F-statistic: 160.9 on 11 and 181 DF,  p-value: < 2.2e-16

# Important vars according to the p-values:
# regionAsia, regionCaribbean, regionEurope, regionLatin Amer, infantMortality

# F statistics shows weather or not the dependent variables have anything to do with the target variable
# The p-value of the F-statistic shows that we can reject H0 and tell that inputs actually can explain 
# the target variable

# Multiple R-squared:  0.9072,	Adjusted R-squared:  0.9016 
# r-squared shows how much of the variance of the dependent variable can be explained by the
# variance of the independent variables (features)
# The value is from 0 to 1 where 1 means that the variance is explained fully
# 0.9072 is a pretty high number which means that we've constructed a pretty good model for
# predicting the life expectency
# R^2 adjusted is pretty close to R^2 which means there aren't unnecessary variables which affect the
# model's performance


model = lm(lifeExpF ~ region+infantMortality, data=df)
summary(model)
# Multiple R-squared:  0.896,	Adjusted R-squared:  0.8921 
# F-statistic: 227.7 on 7 and 185 DF,  p-value: < 2.2e-16
# There isn't any significant change in the R^2 but it decreased
# And the adjusted R^2 also decreased from which we can conclude that we've probably
# ommited some variables which contribute to better model performance
# F-statistics changed, but the p-value is almost the same telling that there is
# significant evidence against H0

par(mfrow = c(2, 2))
plot(model)
# As we can see from the residuals vs fitted plot there is some non-linearity out there so our assumption of having a linear case for the model(data) is not satisfied
# As we can see from the normal QQ plot the normality is violated at the edges so the error term doesn't follow the normal distribution
# As we can see from the scale-location plot there is some pattern of variance from left to right so the equivariance property is violated
# As we can see from the residulas vs leverage plot there are some outliers that do not affect the model so they are not influential











# 3
x_train = df[, !(colnames(df) %in% c("lifeExpF"))]
x_train = as.matrix(sapply(x_train, as.numeric))

# LASSO
model = cv.glmnet(x = x_train, y = df$lifeExpF, alpha=1, standardize=TRUE)
plot(model)
plot(model$glmnet.fit, xvar="lambda", label=TRUE)
model$lambda.min # 0.02962285
model$lambda.1se # 1.22402
coef(model) # => region, fertility, ppgdp, pctUrban are not important
coef(model, s=model$lambda.min)
predictions = predict(model, s = model$lambda.min, newx = x_train)
mean((predictions - df$lifeExpF)^2) # 10.51047


# RIDGE
model <- cv.glmnet(x = x_train, y = df$lifeExpF, alpha=0, standardize=TRUE)
plot(model)
plot(model$glmnet.fit, xvar="lambda", label=TRUE)
model$lambda.min # 1.040115
model$lambda.1se # 2.894182
coef(model) # No coefficients are 0 => all variables play some role in the final result
coef(model, s=model$lambda.min)
predictions = predict(model ,s = model$lambda.min, newx = x_train)
mean((predictions - df$lifeExpF)^2) # 11.45316


# => LASSO outperforms RIDGE regression a little bit according to the RMSE measure
