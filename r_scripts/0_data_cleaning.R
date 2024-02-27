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

# Tidying all variables----
sba_tidy <- sba_original_data |>
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

# Chossing how to deal with NA values----
ggplot(sba_tidy, aes(x = mis_status)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

## Dropping NA
#sba_cleaned <- sba_original_data |>
#  drop_na()


## Downsample
group0 <- sba_tidy |>
  filter(mis_status == "CHGOFF") |>
  slice_sample(n = 3000)

group1 <- sba_tidy |>
  filter(mis_status == "PIF") |>
  slice_sample(n = 3000)

sba_downsampled <- bind_rows(group0, group1)

ggplot(sba_downsampled, aes(x = mis_status)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

# Saving clean dataset
saveRDS(sba_downsampled, here("data/sba.rds"))

