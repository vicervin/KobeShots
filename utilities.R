print.c.m <-function (predictions,truth){
  # Output of results------------------------------------------------
  # Confusion matrix
  c.m <- table(prediction = predictions, truth = truth)
  m.recall <- c.m[2,2] / ( c.m[2,2] + c.m[1,2])
  m.precission <- c.m[2,2] / ( c.m[2,2] + c.m[2,1])
  m.accuracy <- (c.m[2,2] + c.m[1,1])  / length(predictions)
  m.Fscore <-2*m.precission*m.recall/ (m.precission + m.recall)
  c.m.metrics <- list ( precission = m.precission,
                        recall = m.recall,
                        accuracy = m.accuracy,
                        Fscore = m.Fscore,
                        confusion_matrix = c.m
  )
  print(c.m.metrics)
}

split.indices <-function(train_size =0.6 , test_size = 0.2, validate_size = 0.2, N = 15 ){

  set.seed(1988) # Sampling seed
  all_indices <- seq_len(N)
  validation_length <- floor(validate_size * N)
  validation_indices <- sample(all_indices, size = validation_length)
  
  
  train_length <- floor(train_size * N)
  train_indices <- sample(all_indices[-validation_indices], size = train_length)
  
  
  return(list(test = all_indices[-c(validation_indices,train_indices)], 
              train = train_indices,
              validate = validation_indices))
}

