library(devtools)
library(igraph)
library(network)
library(intergraph)
library(sna)
library(statnet)
library(statnetWeb)
install_github("Habet/CSE270")

library(SportsAnalytics270)
# get the roster of the players for the given year
roster<-getPlayerID(2016)
chi<-roster[roster$TEAM_ABBREVIATION=="CHI",]
chi<-as.character(chi[,"PERSON_ID"])

## Run loop to get passings for all the players
passing<-c()

for (i in chi){
  try({
    p<-getPassing(2016, i, "Regular")})
  passing<-rbind(passing,p)
}

# Subset only players in Chicago team
passing <- passing[ passing$PLAYER_ID %in% chi, ]
passing <- passing[ passing$PASS_TEAMMATE_PLAYER_ID %in% chi, ]

# get the adjacency matrix
adj<-passing[passing$PASS_TYPE=="made",
             c("PLAYER_NAME_LAST_FIRST", "PASS_TEAMMATE_PLAYER_NAME", "PASS")]
# Build the graphs
net = network(adj, matrix.type='edgelist')
plot(net,
     label=adj$PASS_TEAMMATE_PLAYER_NAME,
     edge.lwd=adj$PASS/77,
     mode='circle')

length(unique(adj$PLAYER_NAME_LAST_FIRST))
length(unique(adj$PASS_TEAMMATE_PLAYER_NAME))
