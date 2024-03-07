# Final Project ----
# Define and fit Naive Bayes model using second recipe

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(parallel)
library(doParallel)
library(discrim)

num.cores <- detectCores(logical = TRUE)
registerDoParallel(cores = num.cores)

# handle common conflicts
tidymodels_prefer()

# loading neccesary data
load(here("recipes/sba_recipe_nb_2.rda"))
load(here("results/keep_wflow.rda"))
load(here("data_splits/sba_folds.rda"))

# Naive Bayes ----
nb_mod <- naive_Bayes() |> 
  set_mode("classification") |> 
  set_engine("klaR")

nb_wflow <- workflow() |> 
  add_model(nb_mod) |> 
  add_recipe(sba_recipe_nb_2)

nb_fit_2 <-  
  fit_resamples(
    nb_wflow,
    resamples = sba_folds, 
    control = keep_wflow
  )

# write out results (fitted/trained workflows)
save(nb_fit_2, file = here("results/nb_fit_2.rda"))
