# Final Project ----
# Select final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("results/rf_tuned_1.rda"))
load(here("data_splits/sba_train.rda"))

# Best Model --------
select_best(rf_tuned_1, metric = "accuracy")

# finalize workflow -----
final_wflow <- rf_tuned_1 |>
  extract_workflow(rf_tuned_1) |>
  finalize_workflow(select_best(rf_tuned_1, metric = "accuracy"))

# train final model-----
#set seed
set.seed(301)
final_fit <- fit(final_wflow, sba_train)

save(final_fit, file = here("results/final_fit.rda"))
