library(fredr)
library(tidyverse)

df <- fredr(
  series_id = "LREM25TTUSM156S",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2020-12-31")
  
)