extractChunks <- function(x) {
  
  x <- as.String(x)
  wordAnnotation <- annotate(x, list(Maxent_Sent_Token_Annotator(), Maxent_Word_Token_Annotator()))
  POSAnnotation <- annotate(x, Maxent_POS_Tag_Annotator(), wordAnnotation)
  POSwords <- subset(POSAnnotation, type == "word")
  tags <- sapply(POSwords$features, '[[', "POS")
  tokenizedAndTagged <- data.frame(Tokens = x[POSwords], Tags = tags)
  
  tokenizedAndTagged$Tags_mod = grepl("NN|JJ", tokenizedAndTagged$Tags)
  chunk = vector()
  
  chunk[1] = as.numeric(tokenizedAndTagged$Tags_mod[1])
  
  for (i in 2:nrow(tokenizedAndTagged)) {
    
    if(!tokenizedAndTagged$Tags_mod[i]) {
      chunk[i] = 0
    } else if (tokenizedAndTagged$Tags_mod[i] == tokenizedAndTagged$Tags_mod[i-1]) {
      chunk[i] = chunk[i-1]
    } else {
      chunk[i] = max(chunk) + 1
    }
    
  }
  
  text_chunk <- split(as.character(tokenizedAndTagged$Tokens), chunk)
  tag_pattern <- split(as.character(tokenizedAndTagged$Tags), chunk)
  names(text_chunk) <- sapply(tag_pattern, function(x) paste(x, collapse = "-"))
  
  # Extract chunks matching pattern
  res = text_chunk[grepl("JJ-NN|NN.-NN", names(text_chunk))]
  res = sapply(res, function(x) paste(x, collapse =  " "))
  return(res)
  
  gc()
  
}
