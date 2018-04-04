library(dplyr)
library(lubridate)
library(googlesheets)

gs_auth(token = "googlesheets_token.rds")

# Read in data sources

transactions <- gs_title("transactions") %>%
  gs_read() %>%
  mutate(date = ymd(date),
         month = floor_date(date, 'month'))

savings_history <- gs_title("savings-history") %>%
  gs_read()

budget <- gs_title("budget") %>%
  gs_read()

# Pull monthly salary and savings goal

monthly_salary <- budget %>%
  filter(category == "salary") %>%
  pull(budget)

monthly_savings <- budget %>%
  filter(category == "savings") %>%
  pull(budget)

# Remove salary and savings to leave budget per spending category

spending_budget <- budget %>%
  filter(!(category %in% c("salary", "savings")))

# Fudging data for public version

transactions <- transactions %>%
  mutate(description = stringi::stri_rand_strings(nrow(transactions), 10),
         amount = round(amount*runif(nrow(transactions), 0.1, 5), 2))

savings_history <- savings_history %>%
  mutate(balance = round(balance*runif(nrow(savings_history), 0.1, 5), 2))

spending_budget <- spending_budget %>%
  mutate(budget = round(budget*runif(nrow(spending_budget), 0.1, 5), 2))

monthly_salary <- round(monthly_salary*runif(1, 0.1, 5))

monthly_savings <- round(monthly_savings*runif(1, 0.1, 5))
