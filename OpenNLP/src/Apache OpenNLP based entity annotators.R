# Maxent_Entity_Annotator(language = "en", kind = "person", probs = FALSE,
#                         model = NULL)
# 
# Arguments
# 
# language : a character string giving the ISO-639 code of the language being processed by
# the annotator.
# 
# kind : a character string giving the 'kind' of entity to be annotated (person, date, . . . ).
# probs : a logical indicating whether the computed annotations should provide the token
# probabilities obtained from the Maxent model as their 'prob' feature.
# 
# model : a character string giving the path to the Maxent model file to be used, or NULL
# indicating to use a default model file for the given language (if available, see
#                                                                Details).


require("NLP")

s <- paste(c("Pierre Vinken, 61 years old, will join the board as a ",
             "nonexecutive director Nov. 29.\n",
             "Mr. Vinken is chairman of Elsevier N.V., ",
             "the Dutch publishing group."),
           collapse = "")

s <- as.String(s)

## Need sentence and word token annotations.
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()

a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))

