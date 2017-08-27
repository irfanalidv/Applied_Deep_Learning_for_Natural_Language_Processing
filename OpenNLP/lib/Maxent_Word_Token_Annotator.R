Maxent_Word_Token_Annotator <-
  function(language = "en", probs = FALSE, model = NULL)
  {
    f <- Maxent_Simple_Word_Tokenizer(language, probs, model)
    description <-
      sprintf("Computes word token annotations using the Apache OpenNLP Maxent tokenizer employing %s.",
              environment(f)$info)
    
    Simple_Word_Token_Annotator(f, list(description = description))
  }