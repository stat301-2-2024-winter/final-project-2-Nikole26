# Final Project ----
# Analysis of trained models (comparisons)
# Select final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data

# results
# obtain categorical prediction
pred_class <- predict(logistic_fit, sba_test, type = "class")

# obtain probability of category
pred_prob <- predict(logistic_fit, sba_test, type = "prob")

# bind cols together
sba_lg_result <- sba_test |> 
  select(mis_status) |>
  bind_cols(pred_class, pred_prob)

sba_lg_result |> 
  slice_head(n = 5)
accuracy(sba_lg_result, mis_status, .pred_class)
