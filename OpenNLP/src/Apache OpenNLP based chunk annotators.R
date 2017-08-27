require("NLP") 

s <- paste(c("Pierre Vinken, 61 years old, will join the board as a ", 
             "nonexecutive director Nov. 29.\n", 
             "Mr. Vinken is chairman of Elsevier N.V., ",
             "the Dutch publishing group."), 
              collapse = "") 

s <- as.String(s)

sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
