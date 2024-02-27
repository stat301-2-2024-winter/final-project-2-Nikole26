# Final Project ----
# Define and fit baseline models (null and very simple regression model)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
num.cores <- detectCores(logical = TRUE)
registerDoParallel(cores = num.cores)

# handle common conflicts
tidymodels_prefer()

# loading neccesary data
load(here("recipes/sba_recipe_1.rda"))
load(here("results/keep_wflow.rda"))
load(here("data_splits/sba_folds.rda"))

# Null Model (the duh baseline) ----
null_spec <- null_model() |> 
  set_engine("parsnip")|>
  set_mode("classification") 

null_wflow <- workflow()|>
  add_model(null_spec)|>
  add_recipe(sba_recipe_1)

null_fit <- null_wflow |> 
  fit_resamples(
    resamples = sba_folds, 
    control = keep_wflow
  )

# write out results (fitted/trained workflow)
save(null_fit, file = "results/null_fit.rda")


# Binary Logistic Regression ----
logistic_mod <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

logistic_wflow <- workflow() |> 
  add_model(logistic_mod) |> 
  add_recipe(sba_recipe_1)

logistic_fit <- logistic_wflow |> 
  fit_resamples(
    resamples = sba_folds, 
    control = keep_wflow
  )

# write out results (fitted/trained workflows)
save(logistic_fit, file = "results/logistic_fit.rda")
