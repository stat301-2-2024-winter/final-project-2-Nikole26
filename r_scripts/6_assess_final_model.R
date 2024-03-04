# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(janitor)

# loading necessary data
load(here("results/rf_tuned_1.rda"))
load(here("data_splits/sba_test.rda"))
load(here("results/final_fit.rda"))

# Hadling missingness in sba test data
#sba_test_tidy <- sba_test |>
#  mutate(
# approval_fy = ifelse(is.na(approval_fy), mean(approval_fy, na.rm = TRUE), approval_fy),
#    new_exist = ifelse(is.na(new_exist), mean(new_exist, na.rm = TRUE), new_exist)
#  )
sba_test <- sba_test |>
  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) |>
  mutate(across(where(is.factor), ~ifelse(is.na(.), table(.)[which.max(table(.))], .)))

# Predictions -----------
pred_class_rf <- predict(final_fit, sba_test_tidy, type = "class")
pred_prob_rf <- predict(final_fit, sba_test_tidy, type = "prob")
sba_results_rf <- sba_test_tidy |>
  select(mis_status) |>
  bind_cols(pred_class_rf, pred_prob_rf)

save(sba_results_rf, file = here("results/final_results.rda"))

acc_rf <- accuracy(sba_results_rf, mis_status, .pred_class) |>
  select(`Metric` = .metric,
         `Estimate` = .estimate) |>
  knitr::kable()
#knitr::kable(caption = "Best Model's Accuracy", digits = c(NA, 3, 2, 5))

save(acc_rf, file = here("results/acc_rf.rda"))

#Plot-----
conf_mat <- conf_mat(sba_results_rf, mis_status, .pred_class)

save(conf_mat, file = here("results/conf_mat.rda"))