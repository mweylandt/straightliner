#' straightlining
#'
#' Calculate individual-level straightlining indicators
#'
#' @details `straightlining` calculates various individual level- indicators
#' of straightlining for a set of columns in a data set
#'
#' @details **Individual-level Measures.**
#' @details In the formulas below, \eqn{n} refers to the number of questions
#' in a battery, \eqn{r} refers to the response option chosen on a given question,
#' \eqn{i} refers to the respondent, and \eqn{j} is the counter for responses.
#'   \describe{
#'
#'   \item{`"sd"`:}{Battery *Standard Deviation*: simply calculates the
#'   standard deviation of the battery for each respondent. Lower values
#'   indicate more straightlining.}
#'
#'   \item{`"spv"`:}{*Scale Point Variation* (Linville, Salovey, Fischer 1986;
#'    who called it *probability of differentiation*): \deqn{\Rho =
#'   1 - \sum_{j=1}^n{p_{j}^2} } where \eqn{p} is, for each response option the respondent
#'   chooses, the proportion of responses that take the particular value. A
#'   respondent choosing A once and B twice on a 3-question battery has a rho of
#'   \eqn{1 - [\frac{1}{3}^2 + \frac{2}{3}^2] \approx 0.44 }. Lower values
#'   indicate more straightlining. A scale point variation measure for the
#'   battery of questions is calculated by averaging the rhos of all respondents}

#'   \item{`"mir"`:}{*Maximum Identical Rating*: In what proportion of items does
#'   a respondent use their most common response option?
#'   \deqn{MIR = \frac{r_{max}}{n}} Where \eqn{r_{max}} refers to the response choice
#'   most often used by the respondent within this battery.}
#' }
#' @details **Battery-level Measures.**
#' @details These measures give an overview of how much straightlining there
#' was across the whole battery. It might be useful to compare how respondents
#' react to different ways of measuring the same concept.
#'   \describe{
#'   \item{`"nondiff"`:}{*simple nondifferentiation*. Returns the proportion of
#' respondents who *always* use the same response in a battery}
#'
#'   \item{`"mrp"`:}{ *Mean Root Pairs*  (Mulligan, Krosnick, Smith,
#'    Green, and Bizer, 2001). For each respondent, calculate an index
#'    of differentiation by summing the roots of absolute differences between
#'    all pairs of items, and then taking the average.Then normalize this
#'    with reference to the range this index takes on within the sample.
#'    E.g. on a battery consisting of three questions:
#'
#'    \deqn{\text { Respondent } T_{i}=
#'    \frac{\sqrt{\left|r_1-r_2\right|}+\sqrt{\left|r_1-r_3\right|}+
#'    \sqrt{\left|r_2-r_3\right|}}{3} }
#'
#'    \deqn{MRP_i =  \frac{T_i - max(T)} {min(T) - max(T)}}
#'    }
#'
#'   }
#'
#'
#' @references
#'  Kim, Y., Dykema, J., Stevenson, J., Black, P., & Moberg, D. P. (2019).
#'  Straightlining: Overview of measurement, comparison of indicators, and
#'  effects in mail–web mixed-mode surveys. Social Science Computer Review,
#'  37(2), 214-233.
#'
#'  Linville, P. W., Salovey, P., & Fischer, G. W. (1986).
#'  Stereotyping and perceived distributions of social characteristics:
#'  An application to ingroup outgroup perception.
#'  In J. F. Dovidio & S. L. Gaertner (Eds.),Prejudice, discrimination,
#'  and racism (pp. 165–208). Orlando, FL: Academic Press.
#'
#'
#'  Mulligan, K., Krosnick, J., Smith, W., Green, M., & Bizer, G. (2001).
#'  Nondifferentiation on attitude rating scales: A test of survey satisficing
#'  theory. Stanford University. (Unpublished manuscript).
#'
#' @param x data frame or tibble containing survey responses
#' @param varnames a vector of variable names (or indices) to be analysed
#' @param measures a vector of the measures you want a report on. See `Details`
#' for information on these measures
#' @param keep_original if `TRUE` returns the original data frame with the straighlining
#' indicators joined on the right. If `FALSE`, only returns the straightlining 
#' measures in a data frame. Defaults to `FALSE`
#'
#' @return data frame with one column per measure requested, showing results
#' at the individual level. If `keep_original = TRUE`, data frame includes all
#' original data passed to the function as well.
#'
#' @import dplyr
#' @import rlang
#' @export
#'
#' @example inst/examples/straightlining.R



straightlining <- function(x, varnames = NULL,
                           measures = c("mrp", "mir", "qsd", "spv", "nondiff"),
                           keep_original = FALSE) {



  if(is.null(varnames)) {
    varnames = names(x)}


  df <- x[varnames]

  df <- convert_data(df)


  # create results frame and populate it with results
  t <- data.frame(id = rep(NA, nrow(x)))



  if ("mrp" %in% measures) {
    t$mrp <- meanRootPairs(df, clean_data = FALSE)
    }

  if ("mir" %in% measures) {
    t$mir <- maxIdenticalRating(df, clean_data = FALSE)
  }

  if ("qsd" %in% measures) {
    t$qsd <- question_sd(df, clean_data = FALSE)
  }


  if ("spv" %in% measures) {
    t$spv <- scale_point_variation(df, clean_data = FALSE)

  }

  if ("nondiff" %in% measures) {
    t$nondiff <- nondiff(df, clean_data = FALSE)
  }

  full_set <- cbind(x, t[-1])

  if (keep_original) {
    return(full_set)
  }
  t[-1]
}



