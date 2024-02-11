#' Title
#'
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
#' @return vector that indicates whether
#' a given respondent differs in their answers or not. TRUE indicates no differences
#' between answers to this question
#' @import dplyr
#' @import rlang
#'
#' @export
#'
#' @examples
#'
#' survey <- data.frame("respondent" = c("A", "B"),
#' "item1" = c(5, 5),
#' "item2" = c(5, 5),
#' "item3" = c(5, 5),
#' "item4" = c(5, 1))
#'
#' nondiff(survey, varnames = c("item1", "item4"))

nondiff <- function(x,
                    varnames = NULL,
                    verbose = TRUE,
                    clean_data = TRUE,
                    round_digits = 2) {
  if (is.null(varnames)) {
    varnames = names(x)
  }

  df <- x[varnames]
  if (clean_data) {
    df <- convert_data(df)
  }

  # just set all responses to equal and tally FALSE
  nondiff <- apply(df, 1, function(x)
    length(unique(x)) == 1)


  perc <- sum(nondiff) / nrow(df)
  if (verbose) {
    cat(paste0("The proportion of nondifferentiation is ", round(perc, round_digits)))
    cat("\n")
  }
  nondiff

}
