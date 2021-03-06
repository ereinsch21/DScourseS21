library(broom)
library(AER)
library(magrittr)
library(stargazer)
library(tidyverse)
library(skimr)
library(ipumsr)
library(estimatr)
library(modelsummary)
library(ggthemes)
library(rvest)
library(fredr)
library(quantmod)
library(dplyr)
library(forcats)

df <- fredr(
  series_id = "CXU900000LB0905M",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2021-03-01")
)

inc_data<- data.frame(df)
ggplot(data=df) +
  geom_line(mapping=aes(x=date, y=value)) +
  theme_minimal()
ggsave("incomeAA.png")

df1 <- fredr(
  series_id = "CXU900000LB0903M",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2021-03-01")
)

inc_white <- data.frame(df1)
ggplot(data=df1) +
  geom_line(mapping=aes(x=date, y=value)) +
  theme_minimal()
ggsave("incomeW.png")

ddi <- read_ipums_ddi("usa_00011.xml")
data <- read_ipums_micro(ddi)

# Clean data
data %<>% filter(INCTOT<350000)
data %<>% filter(INCTOT>50000)
data %<>% filter(INCWAGE<300000)
data %<>% filter(INCWAGE>10000)
data %<>% mutate(logincwage = log(INCWAGE))
data <- data.frame(data)
str(data)
data <- data %>% 
  mutate(black = as_factor(lbl_clean(RACBLK))  %>% fct_infreq()) 
levels(data$black)
data <- data %>% 
  mutate(black2 = as_factor(lbl_clean(RACBLK))  %>% fct_infreq() %>% fct_rev()) 
levels(data$black2)

ggplot(data = data, aes(x = black2)) + 
  geom_bar() +
  coord_flip()

data %>%
  mutate(black_new = fct_collapse(black,
                                    nonblack = c("No"),
                                    black = c("Yes")
                                  )) %>%
  count(black_new)

data <- data %>%
  mutate(logincwage2 = as_factor(lbl_clean(INCWAGE)) %>% fct_infreq())
levels(data$logincwage2)
