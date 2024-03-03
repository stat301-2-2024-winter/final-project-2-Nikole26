# Final Project ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data---
load(here("data_splits/sba_train.rda"))

# build recipes----
sba_recipe_1 <- 
  recipe(mis_status ~ ., data = sba_train) |>
  step_rm(loan_nr_chk_dgt, name, city, state, bank, bank_state, approval_date, chg_off_date, disbursement_date) |>
  step_unknown(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors())

sba_recipe_baseline <- 
  recipe(mis_status ~ ., data = sba_train) |>
  step_rm(loan_nr_chk_dgt, name, city, state, bank, bank_state, approval_date, chg_off_date, disbursement_date) |>
  step_unknown(all_nominal_predictors()) |>
  step_zv(all_predictors())

sba_recipe_bt <-
  recipe(mis_status ~ ., data = sba_train) |>
  step_rm(loan_nr_chk_dgt, name, city, state, bank, bank_state, approval_date, chg_off_date, disbursement_date) |>
  step_unknown(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_corr(all_predictors(), threshold = 0.7) |>
  step_normalize(all_numeric()) 
  
sba_recipe_knn <-
  recipe(mis_status ~ ., data = sba_train) |>
  step_rm(loan_nr_chk_dgt, name, city, state, bank, bank_state, approval_date, chg_off_date, disbursement_date) |>
  step_unknown(all_nominal_predictors()) |>
  step_dummy(all_nominal(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric()) |>
  step_impute_mean(all_numeric()) 

sba_recipe_rf <- 
  recipe(mis_status ~ ., data = sba_train) |>
  step_rm(loan_nr_chk_dgt, name, city, state, bank, bank_state, approval_date, chg_off_date, disbursement_date) |>
  step_unknown(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors())|>
  step_impute_mean(all_numeric(), -all_outcomes()) 

#step_impute_mean(all_numeric_predictors())
  
# check recipe
sba_recipe_rf |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

# write out recipe(s) ----
save(sba_recipe_1, file = here("recipes/sba_recipe_1.rda"))
save(sba_recipe_baseline, file = here("recipes/sba_recipe_baseline.rda"))
save(sba_recipe_bt, file = here("recipes/sba_recipe_bt.rda"))
save(sba_recipe_knn, file = here("recipes/sba_recipe_knn.rda"))
save(sba_recipe_rf, file = here("recipes/sba_recipe_rf.rda"))
