teams = read.csv('baseballdatabank-2017.1/core/Teams.csv')
teams1 = subset( teams, yearID > 2000 )[, c("teamID","yearID","lgID","G","W","L","R","RA") ]
head( teams1, n=3 )

# winning percentage
teams1$Wpct = teams1$W / (teams1$W+teams1$L)

# Run differential
teams1$RD = teams1$R - teams1$RA
library(ggplot2)
ggplot(teams1,aes(x=teams1$RD,y=teams1$Wpct)) +
  geom_point() +
  xlab('Run Differential') +
  ylab('Winning Percentage')

# Construct linear model
model <- lm(Wpct~RD, data=teams1)
model


# Make prediction for one data point
x = as.data.frame(c(850))
colnames(x) = c("RD")
predict(model, x)



#intercept when the runs are equal to each other, the winning percentage is 0.5, logical.
teams1$Wct_p = teams1$R^2 / (teams1$R^2 + teams1$RA^2)
errors = teams1$Wpct - teams1$Wct_p

sqrt(mean(errors^2))  # Pytagorian error average error will be 4 out of 162.
