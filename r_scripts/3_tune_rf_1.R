# L06 Model Tuning ----
# Define and fit Random Forest Model using baseline recipe

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
library(doParallel)
num.cores <- detectCores(logical = TRUE)
registerDoParallel(cores = num.cores)

# handle common conflicts
tidymodels_prefer()

# load resamples/folds & controls
load(here("results/keep_wflow.rda"))
load(here("data_splits/sba_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/sba_recipe_1.rda"))

# model specifications ----
rf_model <-
  rand_forest(
    trees = 1000, 
    min_n = tune(),
    mtry = tune()
  ) |>
  set_mode("classification") |>
  set_engine("ranger")

# define workflows ----
rf_wflow <- 
  workflow() |>
  add_model(rf_model) |>
  add_recipe((sba_recipe_1))

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_model)

# change hyperparameter ranges
rf_params <- parameters(rf_model) |>
  update(mtry = mtry(c(1, 13)),
         min_n = min_n(c(5, 50))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
set.seed(7102)
rf_tuned_1 <- tune_grid(rf_wflow,
                      sba_folds,
                      grid = rf_grid,
                      control = keep_wflow)

# write out results (fitted/trained workflows) ----
save(rf_tuned_1, file = here("results/rf_tuned_1.rda"))