# this function is not exported from the namespace

convert_data <- function(x) {

  if (ncol(x) < 2) {
    stop("You need to specify at least two variables.")
  }

  classes <- sapply(x,class)

  if (all(classes=="numeric")) {
    return(x)
  } else {

  # convert character to factor
  characters <- which(classes == "character")
  x[characters] <- as.data.frame(lapply(x[characters], as.factor))



  non_numbers <- which(classes != "numeric")
  level_vector <- sapply(x[non_numbers],nlevels)

  warning("Converting some variables to numeric.
      This only works if questions with the same number of responses
      in the survey have the same number of levels in the dataset.
      Here are the numbers of levels present in the data: \n \n" ,
      paste(names(level_vector), level_vector, sep = ": ", collapse = "\n"))



  #print.default(level_vector)
  cat("\n")

  # convert everything to numeric
  x[non_numbers] <- sapply(x[non_numbers],as.numeric)
  classes <- sapply(x,class)

  # return the amended dataset
  x

  }
}


