#' MaxIdenticalRating
#'
#' Calculates the proportion of answers taken up by the
#' most common response by the respondent to this set of questions.
#' Ignores NAs by default.
#'
#' @import dplyr
#' @import rlang
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
#' @return a vector of the same length as the input dataframe that
#' indicates the proportion of answers which take the most common
#' value. Ranges from 0 to 1.
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
#' maxIdenticalRating(survey, varnames = c("item1", "item4"))


maxIdenticalRating <- function(x, varnames = NULL, verbose = TRUE,
                               clean_data = TRUE, round_digits = 2) {


  if(is.null(varnames)) {
    varnames = names(x)}

  no_vars <- length(varnames)

  df <- x[varnames]
  if (clean_data) {
    df <- convert_data(df)
  }



if (verbose) {
  if (sum(stats::complete.cases(x)) < nrow(x)) {
    message("MaxIdenticalRating: There are missing values in your Data.This function ignores NAs.")
    cat("\n")
  }
}
  # Find most common value in each
  # row

most_common <- apply(df,1,function(x) names(which.max(table(x))))
most_common[sapply(most_common, is.null)] <- NA
df$most_common<- unlist(most_common)
df$most_common<- as.numeric(df$most_common)


# determine whether values are equal to this value
df$no_identical <- apply(df, 1, function(x) sum(x[1:no_vars] == x[no_vars+1], na.rm = TRUE))

df$mir <- df$no_identical/no_vars
df$mir[df$mir==0] <- NA #


return(df$mir)


}


