# Logistic regression
titanic <- read.csv( 'Titanic_imputed.csv' )
model <- glm( survived~sex, data = titanic, family = 'binomial' )  # logistic regression model for variable survived


summary( model )                      
exp( model$coefficients )             # intercept = 2.66929134    slope = 0.08843935


table( titanic$survived, titanic$sex )

161 / ( 161 + 682 ) # probability of males to be survived
339 / ( 339 + 127 ) # probability of females to be survived

