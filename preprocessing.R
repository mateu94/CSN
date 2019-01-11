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

#list with the extracted elements
l<-c()

#Extract all the verbs
for (word in 1:1700){
  if(tagged.text[word,3] == "VBD"){
    l<-c(l,tagged.text[word,2])
  }
}


#Extract all the adjectives
for (word in 1:1700){
  if(tagged.text[word,3] == "AJ0"){
    l<-c(l,tagged.text[word,2])
  }
}


#Extract all the nouns NN0,NN1,NN2
for (word in 1:1700){
  w <- tagged.text[word,3]
  if(w == "NN0"| w == "NN1"| w == "NN2"){
    l<-c(l,tagged.text[word,2])
  }
}

any(l == "Villa")

List <- strsplit(dataset$V6_clean2, " ")
#clean new row
dataset$V6_clean3 <- ""

for (row in 1:nrow(dataset)){
  for(el in 1:length(List[[row]])){
  if(any(l == List[[row]][el])){
    dataset$V6_clean3[row] <- paste(dataset$V6_clean3[row],List[[row]][el])
  }
  }
}


