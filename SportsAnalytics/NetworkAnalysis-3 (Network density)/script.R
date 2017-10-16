library(igraph)
library(network)
library(intergraph)
library(sna)
library(statnet)
library(statnetWeb)

mat = rbind( c(0, 1, 1, 0, 0),
             c(0, 0, 1, 1, 0),
             c(0, 1, 0, 0, 0),
             c(0, 0, 0, 0, 0),
             c(0, 0, 1, 0, 0) )

rownames(mat) <- c('A', 'B', 'C', 'D', 'E')
colnames(mat) <- c('A', 'B', 'C', 'D', 'E')


net = network(mat, matrix.type='adjacency')
summary(net)

plot(net,
     main='My Awesome Network',       # Name of the network
     label=network.vertex.names(net), # Labels of nodes
     vertex.cex=3,                    # Vertex size
     label.cex=1.5,                   # Node label size
     edge.lwd=15)                     # Thickness of edge


# Calculate density of the graph
network.density(net)

# Calculate density of the graph with a formula
# edges / (nodes * (nodes-1))
density = network.edgecount(net) / ( network.size(net) * (network.size(net)-1) )
density
