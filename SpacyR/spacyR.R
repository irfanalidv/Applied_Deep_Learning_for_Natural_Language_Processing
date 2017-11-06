#devtools::install_github("kbenoit/spacyr", build_vignettes = FALSE)
library(spacyr)
require(spacyr)
## Loading required package: spacyr
#C:\Users\Irfanalidv\AppData\Local\Programs\Python\Python35\python.exe
spacy_initialize(python_executable = "C:\\Users\\Irfanalidv\\AppData\\Local\\Programs\\Python\\Python35\\python.exe")
txt <- c(d1 = "spaCy excels at large-scale information extraction tasks.",
         d2 = "Mr. Smith goes to North Carolina.")

#Tokenizing and tagging texts
# process documents and obtain a data.table
#It calls spaCy both to tokenize and tag the texts.
#It provides two options for part of speech tagging, plus options to return word lemmas, 
#entity recognition, and dependency parsing.
parsedtxt <- spacy_parse(txt)
head(parsedtxt)
#token lemma   pos entity
text_1<-spacy_parse(txt, tag = TRUE, entity = FALSE, lemma = FALSE)
head(text_1)
#token   pos  tag
text_11<-spacy_parse(txt, tag = TRUE, entity = TRUE, lemma = TRUE)
head(text_11)
#token lemma   pos  tag entity

#Extracting entities
#spacyr can extract entities, either named or "extended".
parsedtxt <- spacy_parse(txt, lemma = FALSE)
entity_extract(parsedtxt)
#doc_id sentence_id         entity entity_type
#1     d2           1          Smith      PERSON
#2     d2           1 North Carolina         GPE
#http://cogcomp.org/software/doc/lbjcoref/edu/illinois/cs/cogcomp/lbj/coref/features/EntityTypeFeatures.html

entity_extract(parsedtxt, type = "all")

#Or, convert multi-word entities into single "tokens":
head(entity_consolidate(parsedtxt))

#Dependency parsing
#Detailed parsing of syntactic dependencies is possible with the dependency = TRUE option:
dep_text<-spacy_parse(txt, dependency = TRUE, lemma = FALSE, pos = FALSE)

