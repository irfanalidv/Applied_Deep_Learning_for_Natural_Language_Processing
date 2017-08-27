Maxent_Sent_Token_Annotator <-
  function(language = "en", probs = FALSE, model = NULL)
  {
    f <- Maxent_Simple_Sent_Tokenizer(language, probs, model)
    description <-
      sprintf("Computes sentence annotations using the Apache OpenNLP Maxent sentence detector employing %s.",
              environment(f)$info)
    
    Simple_Sent_Token_Annotator(f, list(description = description))
  }