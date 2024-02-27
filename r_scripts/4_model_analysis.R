# Final Project ----
# Analysis of trained models (comparisons)
# Select final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data

accuracy(penguins_result, sex, .pred_class)
