library(tidyverse)
library(lubridate)
library(googlesheets)
gs_auth(token = "googlesheets_token.rds")

transactions <- gs_title("Transactions") %>%
  gs_read() %>%
  mutate(Date = mdy(Date),
         Month = floor_date(Date, 'month')) %>%
  filter(Month >= ymd('2016-10-01') & is.na(Labels))
savings_history <- gs_title("Savings History") %>%
  gs_read()
budget <- gs_title("Budget") %>%
  gs_read()

monthly <- gs_title("Monthly") %>% gs_read()
monthly_salary <- monthly[['Salary']]
monthly_savings <- monthly[['Savings Goal']]

# Fudging data for public version
transactions <- transactions %>%
  rowwise() %>%
  mutate(Description = stringi::stri_rand_strings(1, 10),
         Amount = round(Amount*runif(1, 0.1, 5), 2))
savings_history <- savings_history %>%
  rowwise() %>%
  mutate(Amount = round(Amount*runif(1, 0.1, 5), 2))
budget <- budget %>%
  rowwise() %>%
  mutate(Budget = round(Budget*runif(1, 0.1, 5), 2))
monthly_salary <- round(monthly_salary*runif(1, 0.1, 5))
monthly_savings <- round(monthly_savings*runif(1, 0.1, 5))