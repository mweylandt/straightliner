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
#' digits you want#'
#'
#' @return vector of standard deviations for this set of questions
#' NAs are ignored in calculation
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
#' question_sd(survey, varnames = c("item1", "item4"))

scale_point_variation <- function(x, varnames = NULL,  verbose = TRUE,
                                  clean_data = TRUE, round_digits = 2) {

  if(is.null(varnames)) {
    varnames = names(x)}


  df <- x[varnames]
  if (clean_data) {
    df <- convert_data(df)
  }

  no_vars <- ncol(df)

# get unique values for each row
uniques <- apply(df,1,unique, simplify = FALSE)

# for each respondent
spv <- rep(NA, nrow(df))

i=1; l = 1

# for each respondent
for (i in 1:nrow(df)) {
      # get how many unique values there are
      number_items <- length(uniques[[i]])

      props <- NULL
      # for each unique value, calculate what proportion
      # of the answers are that
      for (l in 1:number_items) {
        if (is.na(uniques[[i]][l])) {
          props <- c(props, sum(is.na(df[i,])) / no_vars)

        }else{
        # note I'm not taking mean, but rather
        # denominator is the number of questions in battery
        # this is because I can also calculate NAs as a
        # response category this way

       props <- c(props,
                  sum(df[i,] == uniques[[i]][l], na.rm = TRUE) /
                    no_vars)
        }
      }

      spv[i] <- 1 - sum(props^2)

}

spv_battery <- mean(spv)
maxval <- 1 - (1/no_vars)^2 * no_vars

if (verbose){
  if (base::sum(stats::complete.cases(df)) < nrow(df)) {
    #cat("\n")
    message("scale_point variation: There are missing values in your Data. This function treats NA as a response category of its own")
    cat("\n")
  }

  cat(paste0("The scale point variation measure for this battery of questions is ", round(spv_battery,round_digits), ". \n"))
  cat("\n")
  cat(paste0("The highest possible value of scale point variation for a given respondent is ", round(maxval, round_digits)))
  cat("\n")
  cat("\n")
}


return(spv)


}




