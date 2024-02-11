#' straightlining_qset
#'
#' Get a report aggregate straightlining measures for (several) batteries of
#' questions
#'
#' @param x a data frame or tibble containing the responses you wish to analyze
#' @param variable_list a named list. Each list item should be a vector containing
#' the column names or indices of the questions you want a report on.
#' @param measures a vector of the measures you want a report on. See also \link{straightlining}
#' @param round_digits a numeric value specifying how many significant digits you want
#' @param verbose should the function output extra information, like how it
#' handles missing data or for appropriate measures, the battery-level
#' statistic.
#'
#' @return a data frame containing the measures for every set of questions you
#' requested
#'
#' @details Usually, you want to see whether individuals are straightlining to see
#' whether they are of high-enough quality to include in the analysis. But some
#' questions are also more stimulating than others, and it might be useful to
#' see whether some questions encourage respondents to engage in straightlining.
#' (this should go in a vignette)
#'
#' @details
#' Simple nondifferentiation ('nondiff') and Mean Root Pairs ('mrp') are by their
#' nature designed to report on a set of questions rather than on individual
#' respondents. I also give you the option to return averages for standard
#' deviation ('sd'), scale point variation ('spv'), and maximum Identical Rating ('mir')
#' Others have certainly averaged Scale Point Variation in this way before
#' (Kim et al. 2019, p.19 CHECK THIS), but for all three of these I make no guarantee that the
#' mean is an appropriate way of aggregating results.
#'
#' @references
#'  Kim, Y., Dykema, J., Stevenson, J., Black, P., & Moberg, D. P. (2019).
#'  Straightlining: Overview of measurement, comparison of indicators, and
#'  effects in mail–web mixed-mode surveys. Social Science Computer Review,
#'  37(2), 214-233.
#'
#' @export
#'
#' @examples
#' survey <- data.frame("respondent" = c("A", "B"),
#' "item1" = c(5, 5),
#' "item2" = c(5, 5),
#' "item3" = c(5, 5),
#' "item4" = c(5, 1))
#'
#' batteries <- list(first_two = c("item1", "item2"), second_2 = c(3,4))
#' straightlining_qset(survey, variable_list = batteries)
#
straightlining_qset <- function(x,
                                  variable_list = NULL,
                                  measures = c("mrp", "mir", "qsd", "spv", "nondiff"),
                                  round_digits = 2,
                                  verbose = FALSE) {
  # check variable list is list

  if (!is.list(variable_list)) {
    stop("variable_list is supposed to be a named list")
  }

  results_tab <-
    matrix(ncol = length(measures), nrow = length(variable_list))


  # make results table
  rownames(results_tab) <- names(variable_list)
  results_tab <- as.data.frame(results_tab)
  names(results_tab) = measures


  for (i in 1:length(variable_list)) {
    if(verbose){
      cat("Battery: \n")
      cat(names(variable_list[i]))
      cat("\n")
    }

    # subset dataset
    df <- x[variable_list[[i]]]
    df <- convert_data(df)


    t <- data.frame(id = rep(NA, nrow(x)))
    # do straightlining measures and return
    # relevant stats

    if ("mrp" %in% measures) {
      t$mrp <- meanRootPairs(df, verbose = verbose, clean_data = FALSE, round_digits = round_digits)
      results_tab$mrp[i] <- mean(t$mrp, na.rm = TRUE)

    }

    if ("mir" %in% measures) {
      t$mir <- maxIdenticalRating(df, verbose = verbose, clean_data = FALSE, round_digits = round_digits)
      results_tab$mir[i] <- mean(t$mir, na.rm = TRUE)

    }

    if ("qsd" %in% measures) {
      t$qsd <- question_sd(df, verbose = verbose, clean_data = FALSE, round_digits = round_digits)
      results_tab$qsd[i] <- mean(t$qsd, na.rm = TRUE)

    }


    if ("spv" %in% measures) {
      t$spv <- scale_point_variation(df, verbose = verbose,  clean_data = FALSE, round_digits = round_digits)
      results_tab$spv[i] <- mean(t$spv, na.rm = TRUE)
      results_tab$spv_max[i] <- max(t$spv, na.rm = TRUE)
    }

    if ("nondiff" %in% measures) {
      t$nondiff <- nondiff(df, verbose = verbose, clean_data = FALSE, round_digits = round_digits)
      results_tab$nondiff[i] <- mean(t$nondiff, na.rm = TRUE)

    }



  } # end of loop


  # add battery-level stats as attributes to results_tab
  #attr(results_tab, "spv") <- "hi"

  class(results_tab)  <- c("straightliner", class(results_tab))


  print(results_tab, digits = round_digits)
  invisible(results_tab)

} # end of function

