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


