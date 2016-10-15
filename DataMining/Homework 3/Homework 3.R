#####Homework 3#####
# ATTENTION!!!: whenever you are applying k means clustering, set seed equal to 5.
# You need to set seed every time before performing k means clustering.
# The Global Competitiveness Report 2015-2016 assesses the competitiveness
# landscape of 144 economies, providing insight into the drivers of their 
# productivity and prosperity. The report remains the most comprehensive assessment of 
# national competitiveness worldwide, providing a platform for 
# dialogue between government, business and civil society about the actions 
# required to improve economic prosperity. Competitiveness is defined as the 
# set of institutions, policies and factors that determine the level of 
# productivity of a country. The level of productivity, in turn, sets the 
# level of prosperity that can be earned by an economy.
# Visit http://reports.weforum.org/global-competitiveness-report-2015-2016 for more details

# The different aspects of competitiveness are captured in 12 pillars, 
# which compose the Global Competitiveness Index. The value for pillar for each country is a 
# number between 1-7 and is measured based on the set of sub-indicators (also measured by the scale 1-7)
# Your task is to create clusters of countries based on the pillars of competitivness.

# 1. Load the dataset GCI.csv into R.
gci <- read.csv( 'GCI.csv' )

# 2. Make the variable Country.code as rownames for the dataframe 
# (hint: use rownames() command) (1)
rownames( gci ) <- gci$Country.Code

# 3. Remove the variable Country.Code from the dataframe as you will 
# not need it anymore. (1)
gci$Country.Code <- NULL

# 4. Run hierarchical clustering on the dataset, using 12 pillars as clustering variables (2)
set.seed( 5 )
hc <- hclust( dist( gci[ c(2,13) ] ) )


# 5.Plot the dendogram. What do you think is the optimal number of clusters?
# Try 4 different options. The code should be written in such a 
# way that R gives you a new clear plot each time you try different number 
# of clusters and the rectangles are drown on top of them for each of your options.
# Your goal is to get as nit plots as possible. (2)
plot( hc )
rect.hclust( hc, 10 )
rect.hclust( hc, 5 )  # the best one
rect.hclust( hc, 3 )
rect.hclust( hc, 7 )

# 5.1 Choose one of the numbers of the clusters that you created in problem 5.
# Describe what are the differnces between the clusters in terms of differences in  means. (1)
M<-cutree( hc, 5 )
gci$cluster <- M
attach( gci )
aggdata <- aggregate( gci[-c(1,14)], by=list( gci$cluster ), FUN=mean )
print( aggdata )
detach( gci )

# 5.2 How will you describe your clusters? Try to give names to each of the clusters.(1)
# the first 3 clusters are rich and developed countries
# the second two are poor or developing countries
# cluster1 - developed
# cluster2 - europe
# cluster3 - life quality
# cluster4 - developing
# cluster5 - poor
# Of course there are exceptions, but most of the countries in the clusters can be described by the words above

# 5.3 Looking at the averages of the pillars for each cluster, pick a pillar
# that you think constitutes the largest difference between the clusters.
# Create a boxplot of that pillar against the clusters. Give your comments. (2)
boxplot( gci$Pillar.1~gci$cluster )
boxplot( gci$Pillar.2~gci$cluster )
boxplot( gci$Pillar.3~gci$cluster )
boxplot( gci$Pillar.4~gci$cluster )
boxplot( gci$Pillar.5~gci$cluster )
boxplot( gci$Pillar.6~gci$cluster )
boxplot( gci$Pillar.7~gci$cluster )
boxplot( gci$Pillar.8~gci$cluster )
boxplot( gci$Pillar.9~gci$cluster )
boxplot( gci$Pillar.10~gci$cluster )
boxplot( gci$Pillar.11~gci$cluster )
boxplot( gci$Pillar.12~gci$cluster )
# gci$Pillar.1 is the most different

# 6.Run K-means algorithm, with the same number of clusters that you used in the
# prevous problem. (1) 
set.seed( 5 )
clusters <- kmeans( gci[-c(1,14)], 5 )
clusters$size
clusters

# 7. Are the results the same? Comment.
# (Remember that you might get different numbers (labels) for the 
# clusters if you are using different methods. (2)
# We got almost the same result
# But the number of countries in each cluster is a little different

# Now choose one of the methods and continue with that.

# The dataset WDI indicators has some social and economic data on the countries included in GCI study.
# Note the WDI dataset has the same order as GCI,
# so you can easly add cluster variable to the WDI dataset

# 8.1 Read the dataset into R. Look at the population - what are the min and max values 
# for each cluster? what does this info tell you about the clusters? (2)
wdi <- read.csv( 'WDI.csv' )
# I choose hierarcial clustering
wdi$cluster <- gci$cluster
aggregatedMin <- aggregate( wdi[-c(1)], by=list( wdi$cluster ), FUN=min, na.rm = TRUE )
aggregatedMax <- aggregate( wdi[-c(1)], by=list( wdi$cluster ), FUN=max, na.rm = TRUE )
aggregatedMin$Population
aggregatedMax$Population

# 8.2 Describe your clusters using indicators from the WDI dataset:
# Note that the meanings of the variables are given in a seperate file.
# You need to do a small research, if you want to understand better these variables.
# Try to give description of each cluster in 2-3 sentences. (3)
aggregate( wdi[-c(1)], by=list( wdi$cluster ), FUN=mean, na.rm = TRUE )
# life expectency and unemployment show that countries in the first and second clusters are not developed
# in 3rd, 4th and 5th clusters thr countries are developed

# Global Peace Index is an attempt to measure the relative position of nations' and regions' peacefulness.
# The dataset GPI provides the Global Peace Index scores and rankings 
# for the countries included in the list.
# Note the GPI dataset has the same order as GCI,
# so you can easly add cluster variable to the WDI dataset.

# 9.1 Load the dataset into R.
gpi <- read.csv( 'GPI.csv' )
gpi$cluster <- gci$cluster

# 9.2 Calcualte average score for each cluster. Comment on your findings. (2)
aggregate( gpi[-c(1,2)], by=list( gpi$cluster ), FUN=mean, na.rm = TRUE )$GPI.2016.Score


# 9.3 Estimate rankings for cluster based on the average scores you received in previous step.
# (The rankings for each country are available in the GPI dataset.)(2)
# => in sorted order by clusters (5,3,4,1,2)

# 10. Do your own research on the datasets, find something interesting.(5)
# Do not do trivial manipulations like creating plots without making any valuable
# inferences about those plots.
set.seed( 5 )
wdi <- na.omit( wdi )
clusters <- kmeans( wdi$Life_expectancy, 5 )
clusters$size
clusters
# clusters are very similar to the previous results
# so life expectency plays a significant role in clustering
rm( list = ls() )

#Football data analysis
# The file Soccer.csv summarized various data for football players from 11 European 
# Leagues. The data is collecting based on the FIFA ratings. 
# http://sofifa.com/player/192883 By opening this link, you can find the data for
# Henrikh Mkhitaryan, as well as find the decriptions of the variables. Do some
# reasearch on this web site before starting your homework.

  
# The file Soccer.csv summarized various data for football players from 11 European 
# Leagues. The data is collecting based on the FIFA ratings. 
# http://sofifa.com/player/192883 By opening this link, you can find the data for
# Henrikh Mkhitaryan, as well as find the decriptions of the variables. Do some
# reasearch on this web site before starting your homework.


  
# 11. Load file Soccer.csv into R. Perform k means clustering. 
# Try with at least two different numbers of clusters. (2)
soccer <- read.csv( 'Soccer.csv' )
soccer_scaled <- as.data.frame( scale( soccer[,5:42] ) )
clusters6 <- kmeans( soccer_scaled, 6 )
clusters5 <- kmeans( soccer_scaled, 5 )
clusters4 <- kmeans( soccer_scaled, 4 )
clusters3 <- kmeans( soccer_scaled, 3 )

# 12. Plot the clusters for all the trials (numbers of clusters).
# Do you see any similarity in both graphs?
# Hint: you may find useful package fpc and function called plotcluster. (3)
library( fpc )
plotcluster( soccer_scaled, clusters3$cluster )
plotcluster( soccer_scaled, clusters4$cluster )
plotcluster( soccer_scaled, clusters5$cluster )
plotcluster( soccer_scaled, clusters6$cluster )
# one is the cluster of goalkeepers :)
# vratar, pashtpan, kisapashtpan, harcakvox => clustering in 4 different clusters is probably the best option

# 13. Aggregate the means for all the variables for one of 
# the results that you got in question 2. Give comments about the clusters. (2)
soccer_scaled$cluster <- clusters4$cluster
aggregate( soccer, by=list( soccer$cluster ), FUN=mean, na.rm = TRUE )
# short passing is high for forwards
# sprint is highest for forwards and midfielders
# standing tackle is high in cluster of defenders


# 14. Now perform hierarchical clustering. Again try with several number of clusters. (2)
hclusters <- hclust( dist(soccer_scaled) )
plot( hclusters )
rect.hclust( hclusters, 3 )
rect.hclust( hclusters, 4 ) # kind of good
rect.hclust( hclusters, 5 )
rect.hclust( hclusters, 6 )

# 15. For all the trials, again create plots and try to find patterns.
# Describe the patterns that you noticed. (2)
plotcluster( soccer_scaled, cutree( hclusters, 3 ) ) # goalkeepers are sparated from others but the two remaining clusters are not that distinct
plotcluster( soccer_scaled, cutree( hclusters, 4 ) ) # part of the clusters are merged together, but are distinct enough
plotcluster( soccer_scaled, cutree( hclusters, 5 ) ) # clusters are getting really messy
plotcluster( soccer_scaled, cutree( hclusters, 6 ) ) # complete mess, most of the clusters are merged together

# 16. Based on the patterns and similarities between the graphs that you
# noticed while performing clustering with kmeans and hierarchical 
# clustering, come up with an optimal number of clusters. Choose
# either of the clustering methods, and assign clusters to each of 
# the cases in the soccer dataset. (2)
# The best one I think is dividing into 4 clusters
# It can be explained too. Vro, Pashtpan, Kisapashtpan, Harcakvox
soccer$cluster <- clusters4$cluster        # while doing kmeans these clusters were more distinct than while doing hierarcial
soccer_scaled$cluster <- clusters4$cluster # while doing kmeans these clusters were more distinct than while doing hierarcial


# 17. Aggregate the average data for all the variables for the number
# of the clusters that you chose in question 7. What are the differences 
# between those clusters? Try to give a general description for 5-6 of them. (2)
aggregate( soccer, by=list( soccer$cluster ), FUN=mean, na.rm = TRUE )
# The same comments for the question above
# short passing is high for forwards
# sprint is highest for forwards and midfielders
# standing tackle is high in cluster of defenders
# reaction for forwards is high
# shot power is high for forwards
# free_kick_accuracy is high fro forwards

# 18. Pick a player from each of those clusters. Describe those players in terms of
# their affiliation to the clusters. What are the similarities and differences between them? (1)
# All the differences are described in 17
soccer_scaled$player <- soccer$player_name
# Take Bastian Schweinsteiger from cluster 1 he is wonderful player with wonderful skills
# reaction -> 86.96154
# shot power -> 86.46154 etc
# Take Gianluigi Buffon from cluster 4 (goalkeeper) he is one of the best goalkeepers in the world
# but has relatively small shot power -> 34.58065
# and low acceleration as he is not a forward -> 51.64516
# Wilfried Zaha -> cluster 2 midfielder
# has high acceleration -> 85.36667
# shot power -> 65
# Nikola Petkovic defender -> cluster 3
# slow acceleration -> 64.42857

# 19. Now aggregate the data in a way that you end up with dataframe
# where each row represents a club. Now run clustering on that dataframe
# (use whichever method you prefer.) Aggregate the average values for
# each of the clusters. Again, choose 5-6 variables, compare the clubs
# based on them, and try to give names to the clusters.
df <- as.data.frame( aggregate( soccer[-c(1,2,3,4)], by=list( soccer$team_long_name ), FUN=mean, na.rm = TRUE ) )
# dribling => first is Bayern Munich then comes Barcelona
# Chievo is the amenatariqov team, jahelner are in the team Twente
# Highest avarage strength has Juventus
# Bayern Munich gives the longest passes
# Tallest team is Wolfsburg

# 20. Do your own research on the datasets, find something interesting.
# Do not do trivial manipulations like creating plots without making any valuable
# inferences about those plots. (5)
# Henrik Mkhitaryan is in cluster 1 with Lionel Messi, Bastian Schweinsteiger...
# He Has higher ball controll (84.39474) than Manuel Neuer (30.41379) or Pique (74.85714)


