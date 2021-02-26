library(tidyverse)
library(rvest)

# load website
rwgap = read_html("https://en.wikipedia.org/wiki/List_of_ethnic_groups_in_the_United_States_by_household_income")
rwgap

#table.wikitable:nth-child(6)
income_data <- 
  rwgap %>%
  html_node("table.wikitable:nth-child(6)") %>%
  html_table(fill = TRUE)


