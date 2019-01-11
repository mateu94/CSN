install.packages("koRpus")
install.koRpus.lang("en")
# load the package
library(koRpus)
library(koRpus.lang.en)

# Read in csv files (for the moment only the 100 first lines)
dataset = read.csv(file = "/Users/roberto/Desktop/twitter-data/data.csv",nrows=100,head(FALSE))

# Inspect the result
View(dataset)

# elimination of the elements that are not part of the ASCII encoding.
# elimination of punctuation symbols
dataset$V6_clean1 <- gsub("[^0-9A-Za-z///' ]+", "", dataset$V6)
dataset$V6_clean2 <- gsub("[[:punct:] ]", " ", dataset$V6_clean1)

#Export the data to a text file
write.table(dataset$V6_clean2, file = "data.txt", sep = "\t",row.names = FALSE,col.names = FALSE)

#build the tree tagger
tagged.text <- treetag(
  "data.txt",
  treetagger="manual",
  lang="en",
  TT.options=list(
    path="/Users/roberto/Desktop/treetagger",
    preset="en"
  ),
  doc_id="sample"
)

# Inspect the result
tagged.text

#Extract all the verbs
for (word in 1:1700){
  if(tagged.text[word,3] == "VBD"){
    print(tagged.text[word,2])
  }
}



