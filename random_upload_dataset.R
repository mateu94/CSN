install.packages("LaF")
# load the package
library(LaF)

#https://www.r-bloggers.com/read-random-rows-from-a-huge-csv-file/
shuffle <- function(file, n) {
  lf <- laf_open(detect_dm_csv(file, sep = ",", header = TRUE, factor_fraction = -1))
  return(read_lines(lf, sample(1:nrow(lf), n)))
}
#size of dataset
n <- 10000

# Read in csv files (for the moment only the 100 random lines)
random_dataset<- shuffle("/Users/roberto/Desktop/twitter-data/data.csv", n)
names(random_dataset) <- c("V1", "V2","V3", "V4","V5", "V6")
# Inspect the result
View(random_dataset)
