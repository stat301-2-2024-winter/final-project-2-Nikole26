# Data cleaning
# Deal with missing values

library(tidyverse)
library(here)
library(readr)
library(tidyr)
library(dplyr)
library(lubridate)

sba_original_data <- read_csv(here("data/SBAnational.csv")) |>
  janitor::clean_names()

# Chossing how to deal with NA values----
ggplot(sba_original_data, aes(x = mis_status)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

## Dropping NA
sba_dropping <- sba_original_data |>
  drop_na()

ggplot(sba_dropping, aes(x = mis_status)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

##Imputting values
sba_imputed <- sba_original_data |>
  mutate_if(is.numeric, ~ifelse(is.na(.), mean(., na.rm = TRUE), .))

# Mode imputation for categorical variables
mode_impute <- function(x) {
  mode_val <- names(sort(table(x), decreasing = TRUE))[1]
  x[is.na(x)] <- mode_val
  x
}

sba_imputed <- sba_original_data |>
  mutate_if(is.character, mode_impute)

ggplot(sba_imputed, aes(x = mis_status)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

# Tidying other variables----
sba_tidy <- sba_imputed |>
  mutate(
    chg_off_prin_gr = as.numeric(gsub("[^0-9.]", "", chg_off_prin_gr)),
    gr_appv = as.numeric(gsub("[^0-9.]", "", gr_appv)),
    sba_appv = as.numeric(gsub("[^0-9.]", "", sba_appv)),
    balance_gross = as.numeric(gsub("[^0-9.]", "", balance_gross)),
    disbursement_gross = as.numeric(gsub("[^0-9.]", "", disbursement_gross)),
    disbursement_date = dmy(disbursement_date),
    chg_off_date = dmy(chg_off_date),
    approval_date = dmy(approval_date),
    mis_status = gsub(" ", "", mis_status)
  )

# Saving clean dataset
saveRDS(sba_tidy, here("data/sba.rds"))

