market <- read.csv( 'Market segmentation.csv' )
View( market )

market <- na.omit( market )                      # omit NAs
hc <- hclust( dist( market[c(1,6)] ), "ave" )    # hierarcial clustering take only 1:6 columns from market
plot( hc )                                       # plot the clusters
plot( hc, hang = -1 )


M<-cutree( hc, 3 )    # divide into 3 clusters
market$cluster <- M   # add cluster column to data frama and indicate the cluster for each row
View( market )

attach( market )
aggdata <-aggregate( market, by=list( cluster ), FUN=mean, na.rm=TRUE ) # aggregate by clusters and take mean of other variables
print( aggdata )                                                        # print the result
detach( market )


set.seed( 1997 )
clusters <- kmeans( market[,1:6], 3 )  # calculate k=3 means with 1:6 columns from market
clusters$size                          # 3 clusters containing number of elements -> 12 12 16
names( clusters )


clusters <- kmeans( market, 3 )  # take all variables
clusters$size                    # 8 16 16
names( clusters )


rm( list = ls() )
