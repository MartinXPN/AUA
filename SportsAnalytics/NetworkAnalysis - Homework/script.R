library(devtools)
library(igraph)
library(network)
library(intergraph)
library(sna)
library(statnet)
library(statnetWeb)
library(SportsAnalytics270)
library(data.table)

transfers <- SportsAnalytics270::transfers
transfers <- na.omit(transfers)

# Select from where did the player go during a transfer
net <- network(transfers[, c(5,6)] , matrix.type = "edgelist")

summary(net)
# Network attributes:
  # vertices = 899
  # directed = TRUE
  # hyper = FALSE
  # loops = FALSE
  # multiple = FALSE
  # bipartite = FALSE
  # total edges = 5109 
  # missing edges = 0 
  # non-missing edges = 5109 
  # density = 0.006328487 

plot(net, label=network.vertex.names(net)) # nothing informative. Total mess

# First lets take only those transfers that included selling/buying players
sold_transfers <- transfers[transfers$DESCRIPTION=="Sold",]
# Lets take top k clubs that spent most money
k = 10
dt <- data.table(sold_transfers)
top_money_wasters = dt[,list(sum=sum(PRICE), club=TO), by=TO][1:k]
top_money_gainers = dt[,list(sum=sum(PRICE), club=FROM), by=FROM][1:k]
sum( top_money_gainers$club %in% top_money_wasters$club ) # only 5


# Get network of buyers
top_buyers <- transfers[ transfers$TO %in% top_money_wasters$club, c(5,6)]
top_buyers_net <- network(top_buyers, 
                   matrix.type = "edgelist")
plot(top_buyers_net, 
     label=network.vertex.names(top_buyers_net))

# Get network of sellers
top_sellers <- transfers[ transfers$TO %in% top_money_gainers$club, c(5,6)]
top_sellers_net <- network(top_sellers, 
                          matrix.type = "edgelist")
plot(top_sellers_net, label=network.vertex.names(top_sellers_net))


# Get network of buyers and sellers
top_clubs <- transfers[ transfers$TO %in% top_money_wasters$club & transfers$FROM %in% top_money_gainers$club, c(5,6)]
top_clubs_net <- network(top_clubs, 
                          matrix.type = "edgelist")
plot(top_clubs_net, 
     label=network.vertex.names(top_buyers_net))


mean(sna::betweenness(net))
sna::degree(top_sellers_net)
network.density(net)
