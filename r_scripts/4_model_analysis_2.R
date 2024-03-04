# Final Project ----
# Analysis of tuned models (comparisons) 

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("results/logistic_fit_2.rda"))
load(here("results/nb_fit_2.rda"))
load(here("results/knn_tuned_2.rda"))
load(here("results/bt_tuned_2.rda"))
load(here("results/en_tuned_2.rda"))
load(here("results/rf_tuned_2.rda"))

# Making the table for models using recipe 2
logistic_metrics_2 <- logistic_fit_2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Binary Logistic") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

nb_metrics_2 <- nb_fit_2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Naive Bayes") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

bt_metrics_2 <- bt_tuned_2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Boost Tree") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

en_metrics_2 <- en_tuned_2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Elastic Net") |>
  slice_max(mean) |>
  slice_head(n = 1) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

knn_metrics_2 <- knn_tuned_2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Knn") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

rf_metrics_2 <- rf_tuned_2 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Random Forest") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

model_results_2 <- bind_rows(logistic_metrics_2, nb_metrics_2, bt_metrics_2, en_metrics_2,
                           knn_metrics_2, rf_metrics_2) |>
  arrange(Mean) |>
  knitr::kable()
  #knitr::kable(caption = "Best Estimated Accuracy per model using Recipe 2",
  #             digits = c(NA, NA, 3, 2, 5))

save(model_results_2, file = here("results/model_results_2.rda"))

