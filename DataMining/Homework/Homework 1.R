load( 'Movies.rda' )

# 1.What are the earliest and latest years for which we have a movie in the dataset? (1 point)
range( movies$Year )   # earliest: 1920, latest: 2016

# 2.Create distribution of movies by years. What does this tell you? (1 point)
library( ggplot2 )
qplot( movies$Year, bins=96 ) # 96 = 2016 - 1920
# we can see that the majority of the films in this dataset have year > 1980

library( plyr )
count( movies$Year )
mean( movies$Year )   # 2002.988
median( movies$Year ) # 2005



# 3.Look at the average imdb rating for movies by year. Do you see any trend? (1 point)
avarageRatings <- aggregate(movies$imdbRating, list(movies$Year), mean)
colnames( avarageRatings ) <- c( 'year', 'rating' )
avarageRatings$year[ which.max( avarageRatings$rating ) ] # maximum avarage rating was in 1996
avarageRatings$year[ which.min( avarageRatings$rating ) ] # minimum avarage rating was in 1920

# we can notice that before 1980 the ratings were relatively high and they changed rapidly from year to year
# after about 1970 the avarage rating started to decrease
# and after 2000 the acarage rating is not changing dramatically from year to year
qplot( x = avarageRatings$year, y = avarageRatings$rating, data = avarageRatings)


# 4.Create a boxplot for imdbRating and year, what do you see? (2 points)
boxplot( movies$imdbRating ~ movies$Year)
# XZ ???

# 5.Create a new dataframe which is a subset of the old one.
#The dataframe must contain only the years during which at least 10 movies were
#created. Call the new dataframe movies2. (4 points)
occurences <- data.frame( table( unlist( movies$Year ) ) )
colnames( occurences ) <- c( 'year', 'freq' )
years <- subset( occurences, subset = occurences$freq >= 10 )
movies2 <- subset( movies, subset = movies$Year %in% years$year )
View( movies2 )


# For the upcoming questions use the movies2 dataframe.
# 6.Create a histogram of imdbRating variable. What does it tell you? (1 point)
hist( movies2$imdbRating ) # the most frequent rating is ~7
# from 1 to 9


# 7.Create histogram for a variable tomatoUserRating. What does it tell you?
# Compare with histogram of imdbRating - any insights? (2 points)
hist( movies2$tomatoUserRating ) # the most frequent rating is ~3.2
# from 1.5 to 4.5
# this one is more similar to the graph of the normal distribution centered at ~ 3.2


# 8.Metascore is a score given to the movie by the critics, while imdbRating
# is a rating given by the users.
# What is the meaning of correlation coefficient between these two variables?
# (Hint: cor function will give an error if you dont handle missing values.
# Look at the help for the function to fix that issue). (2 points)
cor( movies2$Metascore, movies2$imdbRating, use = 'pairwise.complete.obs' )
# 0.75 is close to 1 => these two variables are correlated


# 9.Find the movie for which critics and users disagree the most. (Hint:
# You may need to pay attention to the scales of the ratings) (2 points)
difference <- data.frame( diff( as.matrix( c(movies2$Metascore, movies2$imdbRating)) ) )
colnames( difference ) <- c( 'diff' )
movies2$Title[ which.max( difference$diff ) ]


# 10. Create correlation matrix between all rating variables.
# (Hint: Read the descriptions of all the variables to see which of them are ratings.) (1 point)
cor( movies2[,c( "imdbRating", "tomatoRating", "tomatoUserRating" ) ], use = 'pairwise.complete.obs' )



# 11.Do your own research and explain the meanings of the signs of 
# correlation  coefficients.(2 points)



# 12.Create a new dataframe which will show mean 
# gross income generated for each year. Create a plot summarizing that data.
# What trend do you see. Explain. (3 points)
avarageGross <- aggregate(movies2$gross, list(movies2$Year), mean)
colnames( avarageGross ) <- c( 'year', 'gross' )
avarageGross$year[ which.max( avarageGross$gross ) ] # maximum was in 2016
avarageGross$year[ which.min( avarageGross$gross ) ] # minimum was in 1999

# the graph from 1980 to 2016 is like a parabola
# that means the avarage gross was high before 1999 then it started to decrease but after 1999
# the gross started to grow rapidly and reached its maximum during the 2016
qplot( x = avarageGross$year, y = avarageGross$gross, data = avarageGross)


# 13.What do you think, which variable is mostly correlated with the gross income.
# Test your assumption using cor function. Did you guess correct? Elaborate. (2 points)
cor( movies2$imdbVotes, movies2$gross, use = 'pairwise.complete.obs' )       # first highest correlation  0.6302883
cor( movies2$num_voted_users, movies2$gross, use = 'pairwise.complete.obs' ) # second highest correlation 0.6300221
cor( movies2$budget, movies2$gross, use = 'pairwise.complete.obs' )          # 0.1006183
# I thought it had to be the budget, however it had one of the lowest correlations


# 14.Which movie director has the highest average imdbRating? Is his average gross
# also the highest. Give your thoughts on this topic.(Hint: you might find useful
# the phenomenon of time value of money). (3 points)
avarageDirectorRating <- aggregate(movies2$imdbRating, list(movies2$director_name), mean)
avarageDirectorGross <- aggregate(movies2$gross, list(movies2$director_name), mean)
colnames( avarageDirectorRating ) <- c( 'name', 'rating' )
colnames( avarageDirectorGross ) <- c( 'name', 'gross' )
avarageDirectorRating$name[ which.max( avarageDirectorRating$rating ) ] # maximum was [1578]: Tony Kaye
avarageDirectorGross$name[ which.max( avarageDirectorGross$gross ) ]    # maximum was: Lee Unkrich
avarageDirectorGross$gross[ which.max( avarageDirectorRating$rating ) ] # 6712241 (Tony Kaye)
avarageDirectorGross$gross[ which.max( avarageDirectorGross$gross ) ]   # 414984497 (Lee Unkrich) a huge difference
# thus imdb rating and gross are not correlated


# 15.Do your own analysis. Find something interesting (aggregate the data, 
# create plots, etc) (5 points)




# For the upcoming questions, use Employee attriotion database.
# Factors are not set to this data, so R recognises them as integers.
# For some problems you might need setting factors in order for R to operate correctly.
# Make sure your variable types are set correctly before writing the code.

load( 'Employee Attrition.rda' )
# 16.Which position of employee (JobRole) is yielding maximum salary (HourlyRate) 
# on average? Representative of which position (JobRole) has the highest
# hourly rate according to dataset? (2 points)
avarageJobSalary <- aggregate(attrition$HourlyRate, list(attrition$JobRole), mean)
colnames( avarageJobSalary ) <- c( 'JobRole', 'Salary' )
avarageJobSalary
avarageJobSalary$JobRole[ which.max( avarageJobSalary$Salary ) ] # Healthcare Representative


# 17.What is the correlation between the age of the employee and the hourly rate. Can you
# say that the older is the employee, the higher he is earning? Explain. (1 point)
cor( attrition$HourlyRate, attrition$Age, use = 'pairwise.complete.obs' ) # 0.02428654
qplot(attrition$HourlyRate, attrition$Age)
# there is no correlation between these factors


# 18.What is the age of the youngest and the oldest employees in the data? (1 point)
range( attrition$Age ) # youngest: 18, oldest: 60


# 19.Create a histogram of the employees by monthly income. What does it tell you? (1 points)
hist( attrition$MonthlyIncome )
# most of the employees get sallary from 2000 to 7000
# some of them get sallary from 18000 - 20000

# 20.Create a boxplot with Eduation and Percent Salary Hike. What do you see? (2 points)
# Explain your findings.
boxplot(  Education ~ PercentSalaryHike, data = attrition )
# XZ ??


# ----Hypothesis testing----
# 21. Is there a difference between average Monthly Income of employees that churn
# (leave the company) and those who stay within the company? (2 points)


# 22.Is the decision of attriting from the company independent from the gender of
# the employee? (2 points)
femaleAttrition <- subset( attrition$Attrition, subset = (attrition$Gender == 'Female' ) )
maleAttrition <- subset( attrition$Attrition, subset = (attrition$Gender != 'Female' ) )
qplot( femaleAttrition ) # ~500 no ~80 yes    => ~14%  |
qplot( maleAttrition )   # ~ 700 no ~ 180 yes => ~20%  | => there is some relationship between attrition and gender but not so significant


# 23. Choose any two variables that you want and conduct a test either for independence
# or for differences in means. (2 points)
cor( attrition$DistanceFromHome, attrition$DailyRate )   # -0.004985337 => no correlation => independent
plot( attrition$DistanceFromHome, attrition$DailyRate )

# 24. Do your own analysis for attrition data. Find something
# interesting (aggregate the data, create plots, etc) (5 points)