library(mice)
library(modelsummary)
library(tidyverse)
library(dplyr)
# Loading data
data <- read.csv("C:\\Users\\erein\\Documents\\Data Science for Economists\\DScourseS21\\ProblemSets\\PS7\\wages.csv", header = TRUE, stringsAsFactors = FALSE)
df <- data.frame(data)

df1 <- data %>% drop_na(hgc)
df1 <- data %>% drop_na(tenure)

datasummary_skim(df1, output="ps7t1.tex")
# See explanation in pdf/tex write-ups

# Model 1
df2 <- df1 %>% drop_na(logwage)
df1 %<>% mutate(tenure.squared=tenure^2)
df2 %<>% mutate(tenure.squared=tenure^2)
df3 %<>% mutate(tenure.squared=tenure^2)
est1.rob <- lm_robust(logwage ~ hgc + tenure + tenure.squared + as.factor(college) + age + as.factor(married), data=df2)
# Model 2
df3 <- df1 %>% mutate(m_wage = is.na(logwage), logwage1=replace_na(logwage, mean(df1$logwage,na.rm=TRUE)))
est2.rob <- lm_robust(logwage1 ~ hgc + tenure + tenure.squared + as.factor(college) + age + as.factor(married), data=df3)
datasummary_skim(df3)

#Model 3
df3 %<>% mutate(logwage_hat=predict(est1.rob, newdata = df1), 
                logwage2= replace(logwage, m_wage, logwage_hat[m_wage]))
est3.rob <- lm_robust(logwage2 ~ hgc + tenure + tenure.squared + as.factor(college) + age + as.factor(married), data=df3)

# Mice
library(mice)
head(df3)
df3.imp = mice(df3, seed = 12345)
summary(df3.imp)
fit = with(df3.imp, lm(logwage2 ~ hgc + tenure + tenure.squared + age + as.factor(college) + as.factor(married)))
est.mice <- mice::pool(fit)
tidy(est.mice)
# Output
Result <- list(
  lm_robust(logwage ~ hgc + tenure + tenure.squared + as.factor(college) + age + as.factor(married), data=df2),
  lm_robust(logwage1 ~ hgc + tenure + tenure.squared + as.factor(college) + age + as.factor(married), data=df3),
  lm_robust(logwage2 ~ hgc + tenure + tenure.squared + as.factor(college) + age + as.factor(married), data=df3),
  est.mice)
modelsummary(Result, output="ps7t2.tex")
modelsummary(Result)
