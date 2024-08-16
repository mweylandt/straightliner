
<!-- README.md is generated from README.Rmd. Please edit that file -->

# straightliner <img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->
<!-- badges: end -->

This package implements the quantitative measures of straightlining
outlined by [Kim et
al. (2019)](https://doi.org/10.1177/0894439317752406). The package
includes measures for straightlining on the individual level, but can
also generate a report on how much straightlining happens across a set
(or several sets) of questions.

## Installation

You can install the development version of straightliner from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mweylandt/straightliner")
```

## Example

To see which respondents are straightlining, use `straightlining`

``` r
library(straightliner)

survey <- data.frame("respondent" = c("A", "B", "C"),
"item1" = c(5, 5, 4),
"item2" = c(5, 5, 2),
"item3" = c(5, 5, 5),
"item4" = c(5, 1, 3))

st_results <- straightlining(survey, varnames = c("item1", "item3" ,"item4"))
#> The scale point variation measure for this battery of questions is 0.37. 
#> 
#> The highest possible value of scale point variation for a given respondent is 0.67
#> 
#> The proportion of nondifferentiation is 0.33
st_results
#>         mrp       mir      qsd       spv nondiff
#> 1 1.0000000 1.0000000 0.000000 0.0000000    TRUE
#> 2 0.0000000 0.6666667 2.309401 0.4444444   FALSE
#> 3 0.2928932 0.3333333 1.000000 0.6666667   FALSE
```

This returns a dataframe where each row is a respondent and each column
how they performed on a particular measure. You can cbind this to your
original dataset if you want. Alternatively, you can pass the argument
`keep_original = TRUE` to return your original dataset plus these
measures.

To compare batteries of questions to one another, use the
`straightling_qset()` function. This one needs a named list with one
entry for each set of questions, so that it can output a decent table:

``` r
batteries <- list("first two" = c("item1", "item2"),
                   "last two" = c(4,5))

straightlining_qset(survey, batteries, measures = c("mrp", "spv"))
#> 
#>            mrp  spv spv_max
#> first two 0.67 0.17     0.5
#> last two  0.43 0.33     0.5
```

## Measures

For details on the measures call `?straightlining()` to pull up the
documentation and see the ‘details’ section.

## Notes

both `straightlining` and `straightlining_qset` automatically convert
the passed data to numeric if it is not – these calculations don’t work
otherwise. They will warn you if this happens, and let you know how many
levels are present in the data for each variable. If you design a
battery where all responses have the same amount of levels in the survey
(say a 5-point likert) but on one of the questions people only pick the
bottom 4, then the conversion to numbers will cause a misalignment
across this battery and render these statistics *useless*.

## Roadmap

- This package has some different functions than
  [`careless`](https://github.com/ryentes/careless), which is an
  excellent R package. With time I hope to integrate their
  straightlining measures here too, to make it a one-stop shop.
- Examples in the docs won’t work
