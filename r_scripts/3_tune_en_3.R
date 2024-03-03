# Final Project ----
# Define and fit Elastic Net with basic recipe

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
library(doParallel)
library(glmnet)

num.cores <- detectCores(logical = TRUE)
registerDoParallel(cores = num.cores)

# handle common conflicts
tidymodels_prefer()

# load resamples/folds & controls
load(here("results/keep_wflow.rda"))
load(here("data_splits/sba_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/sba_recipe_bt.rda"))

# set engine model
elastic_mod <- 
  logistic_reg(penalty = tune(), mixture = tune()) |>
  set_engine("glmnet")

# update the parameters
elastic_params <- extract_parameter_set_dials(elastic_mod) |> 
  update(penalty = penalty(range = c(-15, 0)))

# grid
elastic_grid <- grid_regular(elastic_params, levels = 5)

# setting workflow 
elastic_workflow <- workflow() |> 
  add_model(elastic_mod) |> 
  add_recipe(sba_recipe_bt)

# tunning workflowed
# set seed 
set.seed(7310)
elastic_tuned_3 <- tune_grid(elastic_workflow, 
                           sba_folds,
                           grid = elastic_grid,
                           control = keep_wflow)

save(elastic_tuned_3, file = here("results/en_tuned_3.rda"))

