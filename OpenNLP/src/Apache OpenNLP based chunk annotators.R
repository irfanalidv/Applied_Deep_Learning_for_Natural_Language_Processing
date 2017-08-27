require("NLP") 

s <- paste(c("Pierre Vinken, 61 years old, will join the board as a ", 
             "nonexecutive director Nov. 29.\n", 
             "Mr. Vinken is chairman of Elsevier N.V., ",
             "the Dutch publishing group."), 
              collapse = "") 

s <- as.String(s)
