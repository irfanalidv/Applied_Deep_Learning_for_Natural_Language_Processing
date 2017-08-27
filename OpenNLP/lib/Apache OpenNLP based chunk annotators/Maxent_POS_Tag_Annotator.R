Maxent_POS_Tag_Annotator <-
  function(language = "en", probs = FALSE, model = NULL)
  {
    f <- Maxent_Simple_POS_Tagger(language, probs, model)
    description <-
      sprintf("Computes POS tag annotations using the Apache OpenNLP Maxent Part of Speech tagger employing %s",
              environment(f)$info)
    for(tag in c("POS_tagset", "POS_tagset_URL")) {
      if(!is.na(val <- environment(f)$meta[[tag]]))
        attr(f, tag) <- val
    }
    
    Simple_POS_Tag_Annotator(f, list(description = description))
  }