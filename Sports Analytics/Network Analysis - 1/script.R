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

network::set.vertex.attribute(net1, 'gender', c("F", "F", "M", "F", "M"))
summary(net1)

network::set.edge.attribute(net1, 'edge.size', c(3, 0, 5, 2, 1))
network::get.edge.attribute(net1, 'edge.size')
network::list.vertex.attributes(net1)


set.seed(777) # Run this with plot and the result will be the same every time, the graph won't be rotated
coordinates = plot(net1,                                   # Plot net1
     label=network::get.vertex.attribute(net1, 'gender'),  # label = gender
     vertex.col='gender',                                  # set different colors for different genders
     vertex.cex=3,
     edge.label='edge.size',                               # Draw values on edges
     edge.lwd='edge.size')                                 # Edges with high values are thicker

View(coordinates)
plot(net1, 
     mode='circle',         # Plot graph s.t nodes form a circle with equal distance from each other
     suppress.axes=F)       # Plot axes
# With iGraph object we need to specify layout=coordinates instead of mode
