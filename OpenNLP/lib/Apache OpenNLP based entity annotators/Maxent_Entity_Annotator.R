Maxent_Entity_Annotator <-
  function(language = "en", kind = "person", probs = FALSE, model = NULL)
  {
    f <- Maxent_Simple_Entity_Detector(language, kind, probs, model)
    description <-
      sprintf("Computes entity annotations using the Apache OpenNLP Maxent name finder employing %s.",
              environment(f)$info)
    
    Simple_Entity_Annotator(f, list(description = description))
  }