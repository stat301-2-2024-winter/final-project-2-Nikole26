# Final Project ----
# Analysis of trained models (comparisons) 
# Select final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("results/logistic_fit.rda"))
load(here("results/nb_fit.rda"))

# Collecting metric
lg_metrics <- logistic_fit |>
  collect_metrics() |>
  mutate(`Model` = "Binary Logistic Regression")

nb_metrics <- nb_fit |>
  collect_metrics() |>
  mutate(`Model` = "Naive Bayes")

# Create table
table_metrics <- bind_rows(lg_metrics, nb_metrics)

# Saving table
save(table_metrics, file = here("results/table_metrics.rda"))
