
if(getRversion() >= "2.15.1")  utils::globalVariables("round_digits")

print.straightliner <- function(x, digits = round_digits) {

  class(x) <- "data.frame"
  cat("\n")
  print(round(x, digits))
  cat("\n")
}



#x <- results_tab
#
#
#
#s <- apply(as.data.frame(x), 1, round)
#s
#
#
#x2 <- as.data.frame(x)
#round(x)
#print(round(as.data.frame(x), 0))
