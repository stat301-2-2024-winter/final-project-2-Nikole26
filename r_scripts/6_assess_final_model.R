# Final Project ----
# Assessing final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(janitor)
library(gt)
library(gtExtras)

# loading necessary data
load(here("results/rf_tuned_1.rda"))
load(here("data_splits/sba_test.rda"))
load(here("results/final_fit.rda"))
load(here("results/final_fit_roc.rda"))

# Hadling missingness in sba test data
sba_test_tidy <- sba_test |>
  mutate(
 approval_fy = ifelse(is.na(approval_fy), mean(approval_fy, na.rm = TRUE), approval_fy),
    new_exist = ifelse(is.na(new_exist), mean(new_exist, na.rm = TRUE), new_exist)
  )

#sba_test <- sba_test |>
#  mutate(across(where(is.numeric), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) |>
#  mutate(across(where(is.factor), ~ifelse(is.na(.), table(.)[which.max(table(.))], .)))

# Predictions using accuracy-----------
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

# Confusion Matrix-----
conf_mat <- tidy(conf_mat(sba_results_rf, mis_status, .pred_class))

#conf_mat_1 <- as.tibble(matrix(c(3742, 8, 30, 3720), nrow = , byrow = TRUE,
#                   dimnames = list(Prediction = c("CHGOFF", "PIF"),
#                                   Truth = c("CHGOFF", "PIF"))))
  
#conf_mat_1 <-
  tibble(
  Prediction = c("CHGOFF", "PIF"), 
  CHGOFF = c(3742, 30),
  PIF = c(8, 3720)
) |>
  gt() |>
  tab_spanner(
    label = "Truth",
    columns = c(CHGOFF, PIF)
  ) |>
  gt_add_divider(columns = "Prediction")


save(conf_mat, file = here("results/conf_mat.rda"))
#saveRDS(conf_mat_1, file = here("results/conf_mat_1.rds"))

# Predictions to create roc_auc-----------
loan_results <- predict(final_fit_roc, new_data = sba_test_tidy) |>
  bind_cols(sba_test_tidy |> select(mis_status)) 

pred_prob <- predict(final_fit_roc, sba_test_tidy, type = "prob")

loan_results <- loan_results |>
  select(mis_status, .pred_class) |>
  bind_cols(pred_prob)

# Visualize results 
# The positive class is PIF since meaning the loan application is accepted by the SBA
sba_curve <- roc_curve(loan_results, mis_status, .pred_PIF)
roc_curve<- autoplot(sba_curve)

save(roc_curve, file = here("results/roc_curve.rda"))

