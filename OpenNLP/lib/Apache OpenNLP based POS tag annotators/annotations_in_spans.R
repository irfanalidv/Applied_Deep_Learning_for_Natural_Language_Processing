annotations_in_spans <-
  function(x, y)
  {
    y <- as.Span(y)
    
    ## An annotation node is contained in a span if it does not start
    ## ahead of the span and does not end later than the span.
    
    ind <- outer(x$start, y$start, ">=") & outer(x$end, y$end, "<=")
    
    lapply(seq_len(ncol(ind)), function(j) x[ind[, j]])
  }