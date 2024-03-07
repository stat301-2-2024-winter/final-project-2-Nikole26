# Data cleaning
# Deal with missing values and tidying dataset

library(tidyverse)
library(here)
library(readr)
library(tidyr)
library(dplyr)
library(lubridate)
library(forcats)

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
    mis_status = factor(gsub(" ", "", mis_status)),
    rev_line_cr = factor(rev_line_cr, levels = c("Y", "N")),
    low_doc = factor(low_doc, levels = c("Y", "N"))
  )

sba_tidy_table <- skimr::skim_without_charts(sba_tidy)

# Analysing the target variable in the original dataset----
original_mis_status_plot <- ggplot(sba_tidy, aes(x = mis_status)) +
  geom_bar(fill = "darkblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

save(original_mis_status_plot, file = here("results/original_mis_status_plot.rda"))

## Dropping NA
#sba_cleaned <- sba_original_data |>
#  drop_na()

## Downsample
group0 <- sba_tidy |>
  filter(mis_status == "CHGOFF") |>
  slice_sample(n = 15000)

group1 <- sba_tidy |>
  filter(mis_status == "PIF") |>
  slice_sample(n = 15000)

sba_downsampled <- bind_rows(group0, group1)

skimr::skim_without_charts(sba_downsampled)

mis_status_plot<- ggplot(sba_downsampled, aes(x = mis_status)) +
  geom_bar(fill = "darkblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

save(mis_status_plot, file = here("results/mis_status_plot.rda"))

# Saving clean dataset 
saveRDS(sba_downsampled, here("data/sba.rds"))

