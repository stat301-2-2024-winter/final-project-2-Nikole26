# Data cl
library(tidyverse)
library(here)
sba_original_data <- read_csv(here("data/SBAnational.csv"))

# Cleaning data
sba <- sba_original_data |>
  janitor::clean_names() |>
  drop_na() 

saveRDS(sba, here("data/sba.rds"))
