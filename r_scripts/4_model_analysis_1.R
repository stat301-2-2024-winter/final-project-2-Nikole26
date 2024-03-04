# Final Project ----
# Analysis of tuned models (comparisons) 

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# loading necessary data
load(here("results/logistic_fit_1.rda"))
load(here("results/nb_fit_1.rda"))
load(here("results/knn_tuned_1.rda"))
load(here("results/bt_tuned_1.rda"))
load(here("results/en_tuned_1.rda"))
load(here("results/rf_tuned_1.rda"))

# Making the table for models using recipe 1
logistic_metrics_1 <- logistic_fit_1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Binary Logistic") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

nb_metrics_1 <- nb_fit_1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Naive Bayes") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

bt_metrics_1 <- bt_tuned |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Boost Tree") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

en_metrics_1 <- elastic_tuned_1 |>
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

knn_metrics_1 <- knn_tuned_1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Knn") |>
  slice_max(mean) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

rf_metrics_1 <- rf_tuned_1 |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  mutate(`Model` = "Random Forest") |>
  slice_max(mean) |>
  slice_head(n = 1) |>
  select(`Model`,
         `Metric` = .metric,
         `Mean` = mean,
         `Num Models` = n,
         `Std Error` = std_err)

model_results_1 <- bind_rows(logistic_metrics_1, nb_metrics_1, bt_metrics_1, en_metrics_1,
                             knn_metrics_1, rf_metrics_1) |>
  arrange(Mean) |>
  knitr::kable()
  #knitr::kable(caption = "Best Estimated Accuracy per model using Recipe 1",
  #             digits = c(NA, NA, 3, 2, 5))

save(model_results_1, file = here("results/model_results_1.rda"))

# Old
# Collecting metric
#lg_metrics <- logistic_fit |>
#  collect_metrics() |>
#  mutate(`Model` = "Binary Logistic Regression")

#nb_metrics <- nb_fit |>
#  collect_metrics() |>
#  mutate(`Model` = "Naive Bayes")

# Create table
#table_metrics <- bind_rows(lg_metrics, nb_metrics)

# Saving table
#save(table_metrics, file = here("results/table_metrics.rda"))
