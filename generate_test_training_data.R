library(igraph)
set.seed(1234)

create_training_test <- function(file) {
  
  # Training and percentage, the rest is test
  training_perc <- 0.8
  test_perc <- 1.0 - training_perc
  
  # Read all the tweets
  tweets <- read.csv(file, header=TRUE)
  
  # Shuffle all tweets
  tweets <- tweets[sample(1:nrow(tweets)),]
  
  training <- head(tweets, training_perc * nrow(tweets))
  test <- tail(tweets, test_perc * nrow(tweets))
  

  write.csv(training, "training.csv")
  write.csv(test, "test.csv")
}



# Only call this if training and test.csv don't exist yet. 
create_training_test("data_processed.csv")

training <- read.csv(file = "training.csv",head(TRUE))
test <- read.csv(file = "test.csv", head(TRUE))

View(training)
