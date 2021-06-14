



# install.packages("network")
# install.packages("visNetwork")
# install.packages("networkD3")
# install.packages('network')
# install.packages('sna')
# install.packages('ndtv')
# install.packages('geomnet')


library(network)
library(sna)
library(ndtv)

library(tidyverse)
library(igraph)
library(network)
library(visNetwork)
library(networkD3)
library(RColorBrewer)
library(geomnet)



getwd()
setwd("C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/OPGG")

edges <- read_csv("./csv/igraph_data/edges.csv")[,2:7]
nodes <- read_csv("./csv/igraph_data/nodes.csv")[,2:4]

# routes_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)



# node?? ???κ??? ?????ϴ? ?Լ?
findLine <- function(data, line)
{   "
      node?? ????�� ?޾Ƽ? ???????��?????
      row ??ȣ?? return ?մϴ?.


      Input
      
        data (Data frame) : nodes ?????? ?��???�� ?޽��ϴ?.
        
        line ( String ) : ?ش? ????�� ???ڿ??? ?޽��ϴ?. 'T'
        
                ex ) : ( 'T', 'M', 'J', 'A', 'S' )

      Return
      
        rowList ( vector ) : 
              ex ) : 
                      [1]   1   3  17  19  ...


    "
    rowList <- c()
    for ( n in seq(length(data$line)) ) {
        if ( str_detect(data$line[n], line)) {
            rowList <- c(rowList, n)
        }
    }
    
    return(rowList)
}




TopEdges <- edges[findLine(edges, "T"),]
MidEdges <- edges[findLine(edges, "M"),]
JungleEdges <- edges[findLine(edges, "J"),]
AdcEdges <- edges[findLine(edges, "B"),]
SupportEdges <- edges[findLine(edges, "S"),]


TopNodes <- nodes[findLine(nodes, "T"),]
MidNodes <- nodes[findLine(nodes, "M"),]
JungleNodes <- nodes[findLine(nodes, "J"),]
AdcNodes <- nodes[findLine(nodes, "A"),]
SupportNodes <- nodes[findLine(nodes, "S"),]


netTop <- graph_from_data_frame(d = TopEdges, vertices = TopNodes, directed = TRUE)
  
visNetwork(TopNodes, TopEdges)  

plot(
  netTop,
  edge.arrow.size = .2,
  # layout =layout.by.attr(routes_igraph, wc=1),
  vertex.color=colors[as.numeric(as.factor(V(netTop)$line))],
  vertex.size=10
)






net <- graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)



V(net)$line


unique(V(net)$line)

brewer.pal(nlevels(), name = 'Spectral')

colors[as.numeric(as.factor(V(net)$line))]





V(net)$count

colors <- sample(col_vector, 18)

  
plot(
      net,
      edge.arrow.size = .2,
      # layout =layout.by.attr(routes_igraph, wc=1),
      vertex.color=colors[as.numeric(as.factor(V(net)$line))],
      vertex.size=10
    )

V(net)$count


distances()


n <- 60

nodes


coords <- layout_(net, as_star())
plot(g, layout = coords)



g <- make_ring(10) + make_full_graph(5)
coords <- layout_(g, as_star())



plot(g4, edge.arrow.size=.5, vertex.color="gold", vertex.size=15, 
     
     vertex.frame.color="gray", vertex.label.color="black", 
     
     vertex.label.cex=0.8, vertex.label.dist=2, edge.curved=0.2) 





## Function to wrap long strings
# Source: http://stackoverflow.com/a/7367534/496488
wrap_strings <- function(vector_of_strings,width){
  as.character(sapply(vector_of_strings, FUN=function(x){
    paste(strwrap(x, width=width), collapse="\n")
  }))
}

# Apply the function to wrap the node labels
V(sub)$label = wrap_strings(V(sub)$label, 12)

## Shrink font
V(sub)$label.cex = 0.8

# Function to increase node separation (for explanatory details, see the link below)
# Source: http://stackoverflow.com/a/28722680/496488
layout.by.attr <- function(graph, wc, cluster.strength=1,layout=layout.auto) {  
  g <- graph.edgelist(get.edgelist(graph)) # create a lightweight copy of graph w/o the attributes.
  E(g)$weight <- 1
  
  attr <- cbind(id=1:vcount(g), val=wc)
  g <- g + vertices(unique(attr[,2])) + igraph::edges(unlist(t(attr)), weight=cluster.strength)
  
  l <- layout(g, weights=E(g)$weight)[1:vcount(graph),]
  return(l)
}

## Make layout reproducible. Different values will produce different layouts,
##  but setting a seed will allow you to reproduce a layout if you like it.
set.seed(3)


plot(sub, vertex.shape="none", vertex.size=1,     
     vertex.label.color=ifelse(V(sub)$value=="l", "blue", "red"),
     layout=layout.by.attr(sub, wc=1))



