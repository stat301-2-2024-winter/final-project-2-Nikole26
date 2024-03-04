# Final Project ----
# Select final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
# Best Model --------
select_best(rf_tuned, metric = "rmse")

# finalize workflow -----
final_wflow <- rf_tuned |>
  extract_workflow(rf_tuned) |>
  finalize_workflow(select_best(rf_tuned, metric = "rmse"))

# train final model-----
#set seed
set.seed(301)
final_fit <- fit(final_wflow, abalone_train)

save(final_fit, file = here("exercise_1/results/final_fit.rda"))

pred_rf <- abalone_test |>
  select(age) |>
  bind_cols(predict(final_fit, abalone_test)) |>
  rename(rf_pred = .pred)

rf_metrics <- metric_set(rmse, rsq, mae, mape)
final_metrics <- rf_metrics(pred_rf, age, estimate = rf_pred) |>
  select(`Metric` = .metric,
         `Estimate` = .estimate) |>
  knitr::kable(caption = "Model's Performance Metrics", digits = c(NA, 3))

save(final_metrics, file = here("exercise_1/results/final_metrics.rda"))