#' Standard Deviation
#'
#'
#' @details
#' NAs are ignored in the calculation
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
#' @return vector of standard deviation for this set of questions
#'
#'
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
#' question_sd(survey, varnames = c("item1", "item3", "item4"))


question_sd <- function(x, varnames = NULL,  verbose = TRUE,
                        clean_data = TRUE, round_digits = 2) {


  if(is.null(varnames)) {
    varnames = names(x)}

  if (sum(stats::complete.cases(x)) < nrow(x)) {
    if (verbose) {
      #cat(" \n")
      message("question_sd: There are missing values in your Data.This function ignores NAs.")
      cat("\n")
    }
  }

  df <- x[varnames]
  if (clean_data) {
    df <- convert_data(df)
  }

  sd_score <- apply(df,1, stats::sd, na.rm = TRUE)
  return(sd_score)


  }

