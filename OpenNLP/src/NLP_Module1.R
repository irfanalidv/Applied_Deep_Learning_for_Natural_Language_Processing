#install.packages("RWeka")
library(RWeka)
library(NLP)
library(openNLP)
library(qdap)
library(rJava)
library(openNLPmodels.en)
# install.packages("openNLPmodels.en",
#                  repos = "http://datacube.wu.ac.at/",
#                  type = "source")


# please drop the data file into the data_area/data.txt location
bio <- readLines("darkness.txt")
print(bio)

bio <- paste(bio, collapse = " ")
print(bio)

library(NLP)
library(openNLP)
library(magrittr)

bio <- as.String(bio)

word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()

bio_annotations <- annotate(bio, list(sent_ann, word_ann))
class(bio_annotations)

head(bio_annotations)

bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)
bio_doc

sents(bio_doc) %>% head(2)

words(bio_doc) %>% head(10)

person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")


pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)

bio_annotations <- annotate(bio, pipeline)
bio_doc <- AnnotatedPlainTextDocument(bio, bio_annotations)

# Extract entities from an AnnotatedPlainTextDocument
entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}

entities(bio_doc, kind = "person")
entities(bio_doc, kind = "location")
entities(bio_doc, kind = "organization")
