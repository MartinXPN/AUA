rm(list=ls())

# 1
n <- 100
x <- rnorm(n, mean = 0, sd = 1)
e <- rnorm(n, mean = 0, sd = 0.25)

y = 4 + 3*x + 2*x^2 + 1*x^3 + e
plot(x, y)

# 2
require(glmnet)

model <- cv.glmnet(x = poly(x, 10), y = y, alpha=0, standardize=TRUE)
plot(model)
plot(model$glmnet.fit, xvar="lambda", label=TRUE)
model$lambda.min
model$lambda.1se
coef(model, s=model$lambda.min)


# 3
model <- cv.glmnet(x = poly(x, 10), y = y, alpha=1, standardize=TRUE)
plot(model)
plot(model$glmnet.fit, xvar="lambda", label=TRUE)
model$lambda.min
model$lambda.1se
coef(model, s=model$lambda.min)


# 4
# As we can see fromt he plots and the coefficents the Lasso regression disregarded the x^4, x^5 ... x^10 
# coefficients which is much closer to the reality while the ridge regression had small but still some
# coefficients for those predictors