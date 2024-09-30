
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

## Individual-level Measures.

In the formulas below, $n$ refers to the number of questions
in a battery, $r$ refers to the response option chosen on a given question,
$i$ refers to the respondent, and $j$ is the counter for responses.
\describe{

- "sd": Battery _Standard Deviation_: simply calculates the
standard deviation of the battery for each respondent. Lower values
indicate more straightlining.

- "spv": _Scale Point Variation_ (Linville, Salovey, Fischer 1986;
who called it _probability of differentiation_):

$$P =  1 - \sum_{j=1}^n{p_{j}^2}$$

  where $p$ is, for each response option the respondent
chooses, the proportion of responses that take the particular value. A
respondent choosing A once and B twice on a 3-question battery has a rho of
$1 - [\frac{1}{3}^2 + \frac{2}{3}^2] \approx 0.44 $. Lower values
indicate more straightlining. A scale point variation measure for the
battery of questions is calculated by averaging the rhos of all respondents
- "mir": _Maximum Identical Rating_: In what proportion of items does
a respondent use their most common response option?

$$MIR = \frac{r_{max}}{n}$$ 

Where $r_{max}$ refers to the response choice
most often used by the respondent within this battery.

## Battery-level Measures.

These measures give an overview of how much straightlining there
was across the whole battery of questions. It might be useful to compare how respondents
react to different ways of measuring the same concept.

- "nondiff": _simple nondifferentiation_. Returns the proportion of
respondents who _always_ use the same response in a battery.

- "mrp": _Mean Root Pairs_  (Mulligan, Krosnick, Smith,
Green, and Bizer, 2001). For each respondent, calculate an index
of differentiation by summing the roots of absolute differences between
all pairs of items, and then taking the average.Then normalize this
with reference to the range this index takes on within the sample.
E.g. on a battery consisting of three questions:

$$\text { Respondent } T_{i}=
   \frac{\sqrt{\left|r_1-r_2\right|}+\sqrt{\left|r_1-r_3\right|}+
   \sqrt{\left|r_2-r_3\right|}}{3} $$

$$ MRP_i =  \frac{T_i - max(T)} {min(T) - max(T)}$$



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
