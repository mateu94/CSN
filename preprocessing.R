install.packages("koRpus")
install.koRpus.lang("en")
# load the package
library(koRpus)
library(koRpus.lang.en)

# Read in csv files (for the moment only the 100 first lines)
dataset_1 = read.csv(file = "/Users/roberto/Desktop/twitter-data/data.csv",nrows=5000,head(FALSE))
dataset_2 = read.csv(file = "/Users/roberto/Desktop/twitter-data/data.csv",nrows=5000,skip=800000,head(FALSE))
dataset = rbind(dataset_1,dataset_2)

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
lengt_tt <- 157257
#list with the extracted elements
l<-c()

#https://courses.washington.edu/hypertxt/csar-v02/penntable.html
#Extract all the verbs of type: be
for (word in 1:lengt_tt){
  w <- tagged.text[word,3]
  if(w == "VB"|w == "VBD"|w == "VBG"| w == "VBN"| w == "VBZ" | w == "VBP" | w == "VBI"| w == "VBB"){
    l<-c(l,tagged.text[word,2])
  }
}

#Extract all the verbs of type: do
for (word in 1:lengt_tt){
  w <- tagged.text[word,3]
  if(w == "VD"|w == "VDD"|w == "VDG"| w == "VDN"| w == "VDZ" | w == "VDP"){
    l<-c(l,tagged.text[word,2])
  }
}

#Extract all the verbs of type: have
for (word in 1:lengt_tt){
  w <- tagged.text[word,3]
  if(w == "VH"|w == "VHD"|w == "VHG"| w == "VHN"| w == "VHZ" | w == "VHP"){
    l<-c(l,tagged.text[word,2])
  }
}

#Extract all the verbs of type: other
for (word in 1:lengt_tt){
  w <- tagged.text[word,3]
  if(w == "VV"|w == "VVD"|w == "VVG"| w == "VVN"| w == "VVZ" | w == "VVP"){
    l<-c(l,tagged.text[word,2])
  }
}


#Extract all the adjectives
for (word in 1:lengt_tt){
  if(tagged.text[word,3] == "AJ0"){
    l<-c(l,tagged.text[word,2])
  }
}


#Extract all the nouns 
for (word in 1:lengt_tt){
  w <- tagged.text[word,3]
  if(w == "NN0"| w == "NN1"| w == "NN2"| w == "NP0"){
    l<-c(l,tagged.text[word,2])
  }
}

#transform sentences in individual words
List <- strsplit(dataset$V6_clean2, " ")
#clean new row
dataset$V6_clean3 <- ""

#extract only the verbs, nouns and adjectives and add them in a new column
for (row in 1:nrow(dataset)){
  for(el in 1:length(List[[row]])){
    #check if word is in sentence
  if(any(l == List[[row]][el])){
    dataset$V6_clean3[row] <- paste(dataset$V6_clean3[row],List[[row]][el])
  }
  }
}

#Exporte the final dataset
write.csv(dataset, file = "data_processed.csv")
#Check if it's correctly exported
dataset_processed = read.csv(file = "data_processed.csv",head(TRUE))
View(dataset_processed)
