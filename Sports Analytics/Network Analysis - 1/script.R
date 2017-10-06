install.packages('igraph')
install.packages('network')
install.packages('intergraph')
install.packages('sna')
install.packages('statnet')
install.packages('statnetWeb')

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


# Construct the same network with another method
# Use list of edges instead of adjacency matrix
other_matrix = cbind(FROM = c( 'A', 'A', 'B', 'B', 'C', 'E' ), 
                     TO   = c( 'B', 'C', 'C', 'D', 'B', 'C' ))

net1 = network(other_matrix, matrix.type='edgelist')
summary(net1)

as.matrix(net1)                            # Get adjacency matrix from network
as.matrix(net1, matrix.type = 'edgelist')  # Get list of edges from network
network_edges = as.matrix(net1, matrix.type = 'edgelist')


# Construct the same network using other network's edges
net2 = igraph::graph_from_edgelist(network_edges)
plot(net2)

# Plot graph using sna package
sna::gplot( net, displaylabels = T )

