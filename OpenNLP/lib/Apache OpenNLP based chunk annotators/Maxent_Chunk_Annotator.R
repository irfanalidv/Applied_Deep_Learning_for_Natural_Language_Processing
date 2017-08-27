Maxent_Chunk_Annotator <-
  function(language = "en", probs = FALSE, model = NULL)
  {
    f <- Maxent_Simple_Chunker(language, probs, model)    
    description <-
      sprintf("Computes chunk annotations using the Apache OpenNLP Maxent chunker employing %s.",
              environment(f)$info)
    
    Simple_Chunk_Annotator(f, list(description = description))
  }