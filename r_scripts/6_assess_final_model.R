# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("results/rf_tuned_1.rda"))
load(here("data_splits/sba_train.rda"))

pred_rf <- sba_test |>
  select(mis_status) |>
  bind_cols(predict(final_fit, sba_test)) |>
  rename(rf_pred = .pred)

rf_metrics <- metric_set(accuracy, rmse, rsq, mae, mape)
final_metrics <- rf_metrics(pred_rf, age, estimate = rf_pred) |>
  select(`Metric` = .metric,
         `Estimate` = .estimate) |>
  knitr::kable(caption = "Model's Performance Metrics", digits = c(NA, 3))

#save(final_metrics, file = here("exercise_1/results/final_metrics.rda"))