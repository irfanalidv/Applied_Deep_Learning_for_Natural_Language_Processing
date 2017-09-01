library(openNLP)
library(openNLPdata)
library(openNLPmodels.en)
library("qdap")
library(stringr)
library(rJava)
require("NLP") 
#Step 1: POS Tagging


#We will try the approach for 1 tweet; Finally we will convert this into a function
x <- "the text of the tweet"
x <- as.String(x)

# Before POS tagging, we need to do Sentence annotation followed by word annotation
wordAnnotation <- annotate(x, list(Maxent_Sent_Token_Annotator(), Maxent_Word_Token_Annotator()))

# POS tag the words & extract the "words" from the output
POSAnnotation <- annotate(x, Maxent_POS_Tag_Annotator(), wordAnnotation)
POSwords <- subset(POSAnnotation, type == "word")
# Extract the tags from the words
tags <- sapply(POSwords$features, '[[', "POS")

# Create a data frame with words and tags
tokenizedAndTagged <- data.frame(Tokens = x[POSwords], Tags = tags)
####################################################################################

#Step 2
# Define a flag(tags_mod) for pos tags -
#Flag set to 1 if it contains the POS tag we are interested in else 0
# In this case we only want Noun and Adjective tags (NN, JJ)
# Note that this will also capture variations such as NNP, NNPS etc

tokenizedAndTagged$Tags_mod = grepl("NN|JJ", tokenizedAndTagged$Tags)

# Initialize a vector to store chunk indexes
chunk = vector()  

# Iterate thru each word and assign each one to a group
# if the word doesn't belong to NN|JJ tags 
#(i.e. tags_mod flag is 0) assign it to the default group (0)
# If the ith tag is in "NN|JJ" 
#(i.e. tags_mod flag is 1) assign it to group 
#i-1 if the (i-1)th tag_mod flag is also 1; else assign it to a new group

chunk[1] = as.numeric(tokenizedAndTagged$Tags_mod[1])
for (i in 2:nrow(tokenizedAndTagged)) {
  
  if(!tokenizedAndTagged$Tags_mod[i]) {
    chunk[i] = 0
  } else if (tokenizedAndTagged$Tags_mod[i] == tokenizedAndTagged$Tags_mod[i-1]) {
    chunk[i] = chunk[i-1]
  } else {
    chunk[i] = max(chunk) + 1
  }
  
}

#Finally extract matching pattern

# Split and chunk words
text_chunk <- split(as.character(tokenizedAndTagged$Tokens), chunk)
tag_pattern <- split(as.character(tokenizedAndTagged$Tags), chunk)
names(text_chunk) <- sapply(tag_pattern, function(x) paste(x, collapse = "-"))

# Extract chunks matching pattern
# We will extract JJ-NN chunks and two or more continuous NN tags 
# "NN.-NN" -> The "." in this regex will match all variants of NN: NNP, NNS etc
res = text_chunk[grepl("JJ-NN|NN.-NN", names(text_chunk))]

