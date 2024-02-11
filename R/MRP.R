#' Mean Root Pairs
#'
#' Calculate the mean Root Pairs measure for each respondent
#' over a set of supplied variables
#'
#' @import dplyr
#' @import rlang
#'
#' @export
#' @name meanRootPairs
#' @param x dataframe or tibble containing survey responses
#' @param varnames vector of variable names
#' @param verbose should the function output extra information, like how it
#' handles missing data or for appropriate measures, the battery-level
#' statistic.
#' @param clean_data should strings and factors be converted to numbers?
#' Defaults to TRUE. (These functions only work on numeric columns)
#' @param round_digits a numeric value specifying how many significant
#' digits you want
#'
#' @return a vector containing the measure for each row of the dataset calculated
#' across the variables specified in `varnames`
#' @examples
#'
#' survey <- data.frame("respondent" = c("A", "B"),
#' "item1" = c(5, 5),
#' "item2" = c(5, 5),
#' "item3" = c(5, 5),
#' "item4" = c(5, 1))
#'
#'
#' meanRootPairs(survey, varnames = c("item1", "item4"))



meanRootPairs <- function(x, varnames = NULL,
                          verbose = TRUE,
                          clean_data = TRUE,
                          round_digits = 2) {



  if(is.null(varnames)) {
    varnames = names(x)}


  df <- x[varnames]

  if (clean_data) {
    df <- convert_data(df)
  }

  combos <- utils::combn(names(df), m=2, simplify = FALSE)

  pairsList <- list()
  # calculate the pairs
  # each entry in combos only has 2 values (because it's a set of
  # pairs). Select from our df the first variable and the second one
  # of this pair combination, then subtract them all from each other
  # and take absolute value.
  # these values are stored in pairs list.

  for (i in 1:length(combos)){
    pairsList[[i]]  <- abs(df[,combos[[i]][1]] - df[,combos[[i]][2]])
  }



  # sum across
  t <- as.data.frame(pairsList)
  names(t) <- paste0(combos)

  #rowwise even needed now?
  t <- t %>% rowwise() %>% mutate(sums = rowSums(across(.cols = everything()), na.rm = TRUE),
                                  mrp_t= sqrt(sums)/length(vars)) %>%
    ungroup()

  tempmax <- max(t$mrp_t, na.rm=TRUE)
  tempmin <- min(t$mrp_t, na.rm=TRUE)


  if (tempmin == tempmax)  {
    t$mrp <- 0
  } else {
    t$mrp <- (t$mrp_t - tempmax)/
      (tempmin - tempmax)

  }


  return(t$mrp)

  }


