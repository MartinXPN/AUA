# update the package SportsAnalytics270
library(devtools)
install_github('Habet/CSE270')
library(SportsAnalytics270)
library(intergraph)

# get the data wc_14_final
# look inside, it is a list of 4 dataframes
data('wc_14_final')
wc_14_final$argentina_passing
wc_14_final$argentina_team

# if you want to access the dataframe in the list use: list$dfname
wc_14_final$argentina_team$Shirt_number
wc_14_final$argentina_team$Player_name
# Now we have a weighted sociomatrix as passing network
# Means that the elements in the matrix are not just 1's 
# but are showing the weights/attribute of the edge.
# use the following command from igraph
net <- igraph::graph.adjacency(as.matrix(wc_14_final$argentina_passing),
                             mode="directed",
                             weighted=TRUE,
                             diag=FALSE)
net <- asNetwork(net)
summary(net)
plot(net,
     #label=wc_14_final$argentina_team$Shirt_number,
     label=wc_14_final$argentina_team$Player_name,
     vertex.cex=3,                    # Vertex size
     label.cex=1.5,                   # Node label size
     mode='circle',                          # Organize everything in circle
     edge.lwd=wc_14_final$argentina_passing) # Thickness of edge


# do the same thing for Germany with igraph object
net <- igraph::graph.adjacency(as.matrix(wc_14_final$germany_passing),
                               mode="directed",
                               weighted=TRUE,
                               diag=FALSE)
plot(net,
     #label=wc_14_final$argentina_team$Shirt_number,
     vertex.label=wc_14_final$germany_team$Player_name,   # Print player names on nodes
     edge.arrow.size=0.1,                                 # Arrow size
     layout=igraph::layout.circle,                        # Organize everything in circle
     edge.width=as.matrix(wc_14_final$germany_passing)/3) # Thickness of edge

plot.default(wc_14_final$argentina_team$Pass_attempted, xlab = wc_14_final$argentina_team$Player_name)
wc_14_final$argentina_team$Player_name
wc_14_final$argentina_team$Pass_attempted - wc_14_final$argentina_team$Pass_completed

# load the file arg_edgelist, this is the edgelist representation of the 
# passing network for Argentina.
# make a network object out of it, 
# Add weights attribute for the edges, using the third column from the dataframe

# Now look at the variables in germany_team and argentina_team, which variables 
# can you use as a node attributes ?

# at them to your network objects as node/vertex.attributes

# Do this with both network and igraph objects

# Now plot your network, use node and edge attributes to change the colors,
# edgeline thickness, etc

# Use different plot layouts


# Install package "circlise" with install.packages, if it is not installed
# look at the function chordDiagram, it takes as an input sociomatrix
# use as.matrix if needed

# can figure out how to use heatmap from R basic package works and what it does?
# Try on our dataset

# Now the fun part:
# https://goo.gl/VtcRhy from here you can find the initial formations of the team
# can you alter the coordinates of the graph in a way, to replicate the positions of the players on the graph?
# you can use first 11 entries in the sociomatrix, as those were in the starting lineup
# do it for each team, with horizontal layout.

