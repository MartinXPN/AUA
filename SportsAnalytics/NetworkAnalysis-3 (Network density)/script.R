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


ork(mat, matrix.type='adjacency')
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

# Get degree of vertices
degree(net)                    # out + in degree
degree(net, cmode='outdegree') # outgoing degree
degree(net, cmode='indegree')  # ingoing degree


# Calculate closeness for every vertex in the graph
1 / sna::closeness(net, gmode='graph')                # Calculate with sna
net <- asIgraph(net)                                  # Convert to igraph
1 / igraph::closeness(net, mode='all', normalized=T)  # Calculate with igraph

# Calculate closeness for weighted graph
net <- asNetwork(net)
network::set.edge.attribute(net, 'weight', c(30, 10, 5, 2, 6))
1 / igraph::closeness(asIgraph(net), normalized = T)


# Calculate number of occurences of each vertex in all possible shortest paths
igraph::betweenness(asIgraph(net))
