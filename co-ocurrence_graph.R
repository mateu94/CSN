library(igraph)

N <- 3

coocurrence_graph <- make_empty_graph(directed = FALSE)
coocurrence_graph <- set_edge_attr(coocurrence_graph, "coocurrences", value = 0)

tweets <- read.csv("tweets.csv", header=TRUE)
for(i in 1:nrow(tweets)) {
  tweet <- tweets$V6_clean3[i]
  tweet <- trimws(tweet, "l")
  tweet <- tolower(tweet)
  tweet <- strsplit(tweet, " ")
  # First N elements
  for(j in 1:(N-1)) {
    tweet1 <- tweet[[1]][j]
    for(k in (j+1):N ) {
      if(k <= N && k <= length(tweet[[1]])) {
        tweet2 <- tweet[[1]][k]
        if((tweet1 %in% vertex_attr(coocurrence_graph, "name")) && (tweet2 %in% vertex_attr(coocurrence_graph, "name"))) {
          # If the vertices exist
          if(tweet1 != tweet2) {
            # If they are different
            if(!are_adjacent(coocurrence_graph, tweet1, tweet2)) {
              # If they are not connected we join them
              coocurrence_graph <- add_edges(coocurrence_graph, c(tweet1, tweet2), coocurrences = 1)
            }
            else {
              # If they are already connected we increase the coocurrence value
              edge <- get.edge.ids(coocurrence_graph, c(tweet1, tweet2))
              coocurrences_value <- edge_attr(coocurrence_graph, "coocurrences", index = edge)
              coocurrence_graph <- set_edge_attr(coocurrence_graph, "coocurrences", value = coocurrences_value + 1, index = edge)
            }
          }
        }
        else {
          # If some of them do not exist yet
          if(!tweet1 %in% vertex_attr(coocurrence_graph, "name")) {
            coocurrence_graph <- add_vertices(coocurrence_graph, 1, name = tweet1)
          }
          if(!tweet2 %in% vertex_attr(coocurrence_graph, "name")) {
            coocurrence_graph <- add_vertices(coocurrence_graph, 1, name = tweet2)
          }
          # We join them if they are different
          if(tweet1 != tweet2) {
            coocurrence_graph <- add_edges(coocurrence_graph, c(tweet1, tweet2), coocurrences = 1)
          }
        }
      }
    }
  }
  
  # Rest of elements
  if(length(tweet[[1]]) > N) {
    for(j in 2:(length(tweet[[1]])-N+1)) {
      tweet2 <- tweet[[1]][j+N-1]
      for(k in j:(j+N-2)) {
        tweet1 <- tweet[[1]][k]
        if(tweet2 %in% vertex_attr(coocurrence_graph, "name")) {
          # If tweet2 exists
          if(tweet1 != tweet2) {
            # If they are different
            if(!are_adjacent(coocurrence_graph, tweet1, tweet2)) {
              # If they are not connected we join them
              coocurrence_graph <- add_edges(coocurrence_graph, c(tweet1, tweet2), coocurrences = 1)
              }
            else {
              # If they are already connected we increase the coocurrence value
              edge <- get.edge.ids(coocurrence_graph, c(tweet1, tweet2))
              coocurrences_value <- edge_attr(coocurrence_graph, "coocurrences", index = edge)
              coocurrence_graph <- set_edge_attr(coocurrence_graph, "coocurrences", value = coocurrences_value + 1, index = edge)
            }
          }
        }
        else {
          # Tweet2 does not exist yet
          coocurrence_graph <- add_vertices(coocurrence_graph, 1, name = tweet2)
          # We join them
          if(tweet1 != tweet2) {
            # If they are different
            coocurrence_graph <- add_edges(coocurrence_graph, c(tweet1, tweet2), coocurrences = 1)
          }
        }
      }
    }
  }
}

edge.attributes(coocurrence_graph)
write_graph(coocurrence_graph, "co-occurrence_graph", "graphml")
# plot(coocurrence_graph, edge.label = E(coocurrence_graph)$coocurrences)