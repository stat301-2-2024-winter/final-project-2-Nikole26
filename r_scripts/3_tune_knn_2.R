# Final Project ----
# Define and fit Knn with basic recipe

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
knn_model <-
  nearest_neighbor(mode = "classification",
                   neighbors = tune()) |>
  set_engine("kknn")

# define workflows ----
knn_wflow <- 
  workflow() |>
  add_model(knn_model) |>
  add_recipe((sba_recipe_1))

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_model)
# change hyperparameter ranges
knn_params <- parameters(knn_model) |>
  update(neighbors = neighbors(range = c(1, 13))) 
# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
set.seed(7026)
knn_tuned_1 <- tune_grid(knn_wflow,
                       sba_folds,
                       grid = knn_grid,
                       control = keep_wflow)

# write out results (fitted/trained workflows) ----
save(knn_tuned_1, file = here("results/knn_tuned_1.rda"))
