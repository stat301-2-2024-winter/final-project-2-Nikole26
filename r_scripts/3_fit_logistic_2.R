# Final Project ----
# Define and fit baseline models (null and very simple regression model)

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
load(here("recipes/sba_recipe_2.rda"))
load(here("results/keep_wflow.rda"))
load(here("data_splits/sba_folds.rda"))

# Baseline Model: Binary Logistic Regression ----
logistic_mod <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

logistic_wflow <- workflow() |> 
  add_model(logistic_mod) |> 
  add_recipe(sba_recipe_2)

logistic_fit_2 <-  
  fit_resamples(
    logistic_wflow,
    resamples = sba_folds, 
    control = keep_wflow
  )

# write out results (fitted/trained workflows)
save(logistic_fit_2, file = here("results/logistic_fit_2.rda"))
