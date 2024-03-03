# Final Project ----
# Define and fit Boost Tree with recipe 1

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

# loading neccesary data
load(here("recipes/sba_recipe_1.rda"))
load(here("results/keep_wflow.rda"))
load(here("data_splits/sba_folds.rda"))

# model specifications ----
bt_model <- boost_tree(mode = "classification", 
                       mtry = tune(),
                       min_n = tune(),
                       learn_rate = tune()) |> 
  set_engine("xgboost")

# define workflows ----
bt_wflow <- 
  workflow() |>
  add_model(bt_model) |>
  add_recipe(sba_recipe_1)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_model)
# change hyperparameter ranges
bt_params <- parameters(bt_model) |>
  update(mtry = mtry(c(1, 10)), 
         min_n = min_n(c(600, 1500)),
         learn_rate = learn_rate(c(0.001, 0.1))) 
# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
#set seed
set.seed(712)
bt_tuned_1 <- tune_grid(bt_wflow,
                      sba_folds,
                      grid = bt_grid,
                      control = keep_wflow)

# write out results (fitted/trained workflows) ----
save(bt_tuned_1, file = "results/bt_tuned_1.rda")


