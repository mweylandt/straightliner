 survey <- data.frame("respondent" = c("A", "B"),
 "item1" = c(5, 5),
 "item2" = c(5, 5),
 "item3" = c(5, 5),
 "item4" = c(5, 1))
 straightlining(survey, varnames = c("item1", "item4"))
