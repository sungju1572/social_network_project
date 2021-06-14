nodes <- data.frame(id = 1:10, 
                    label = paste("Node", 1:10),                                 # add labels on nodes
                    group = c("GrA", "GrB"),                                     # add groups on nodes 
                    value = 1:10,                                                # size adding value
                    shape = c("square", "triangle", "box", "circle", "dot", "star",
                              "ellipse", "database", "text", "diamond"),                   # control shape of nodes
                    title = paste0("<p><b>", 1:10,"</b><br>Node !</p>"),         # tooltip (html or character)
                    color = c("darkred", "grey", "orange", "darkblue", "purple"),# color
                    shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE))                  # shadow

head(nodes)

edges <- data.frame(from = sample(1:10, 8), to = sample(1:10, 8),
                    label = paste("Edge", 1:8),                                 # add labels on edges
                    length = c(100,500),                                        # length
                    arrows = c("to", "from", "middle", "middle;to"),            # arrows
                    dashes = c(TRUE, FALSE),                                    # dashes
                    title = paste("Edge", 1:8),                                 # tooltip (html or character)
                    smooth = c(FALSE, TRUE),                                    # smooth
                    shadow = c(FALSE, TRUE, FALSE, TRUE))                       # shadow
head(edges)

visNetwork(nodes, edges, width = "100%")