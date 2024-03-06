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

# finalize workflow for accuracy-----
final_wflow <- rf_tuned_1 |>
  extract_workflow(rf_tuned_1) |>
  finalize_workflow(select_best(rf_tuned_1, metric = "accuracy"))

# finalize workflow for roc-----
final_wflow_roc <- rf_tuned_1 |>
  extract_workflow(rf_tuned_1) |>
  finalize_workflow(select_best(rf_tuned_1, metric = "roc_auc"))

# train final model-----
#set seed
set.seed(301)
final_fit <- fit(final_wflow, sba_train)

set.seed(103)
final_fit_roc <-  fit(final_wflow_roc, sba_train)

# saving results-------
save(final_fit, file = here("results/final_fit.rda"))
save(final_fit_roc, file = here("results/final_fit_roc.rda"))
