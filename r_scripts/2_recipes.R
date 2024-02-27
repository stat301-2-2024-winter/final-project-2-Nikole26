# Final Project ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(ROSE)

# handle common conflicts
tidymodels_prefer()

# load training data---
load(here("data_splits/sba_train.rda"))

# build recipes----
sba_recipe_1 <- 
  recipe(mis_status ~ ., data = sba_train) |>
  step_rm(loan_nr_chk_dgt, name, city, state, bank, bank_state, approval_date, chg_off_date, disbursement_date) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors()) 

# check recipe
sba_recipe_1 |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

# write out recipe(s) ----
save(sba_recipe_1, file = here("recipes/sba_recipe_1.rda"))
