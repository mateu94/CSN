library(igraph)

# Calculates the top n words based on the occurrence graph and two centrality measures (closeness and distance).
calc_top_words <- function(n, name) {
  # Read the centrality graph again
  cooccurrence_graph = read_graph(name, format=c("graphml"))
  
  # Get the degree centrality
  degree.cent <- centr_degree(cooccurrence_graph, mode = "all")
  
  # Get the closeness centrality
  closeness.cent <- closeness(cooccurrence_graph, mode = "all")
  
  # Get the top n words
  closeness_top <- V(cooccurrence_graph)[sort(closeness.cent, index.return=TRUE, decreasing=TRUE)$ix[1:n]]
  degree_top <- V(cooccurrence_graph)[sort(degree.cent$res, index.return=TRUE, decreasing=TRUE)$ix[1:n]]
  
  # Write those top n words to a file
  write(closeness_top$name, paste(c("top_", n, "_closeness.txt"), collapse = ""))
  write(degree_top$name, paste(c("top_", n, "_distance.txt"), collapse = ""))
}

calc_top_words(100, "co-occurrence_graph")