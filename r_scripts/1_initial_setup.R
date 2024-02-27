# Final Project: Set up
# Initial data checks & data splitting

# Random process in script, seed set right before it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

# load data ----
sba <- readRDS(here("data/sba.rds"))

# inspecting target variable
skimr::skim_without_charts(sba$mis_status)

p1 <- 
  ggplot(sba, aes(x = mis_status)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Distribution of Loan Status",
       x = "Loan Status",
       y = "Count")

# quick quality check----
sba|>
  naniar::miss_var_summary()

#inital split of the data
# set seed
set.seed(3012)
sba_split <- 
  sba |>
  initial_split(prop = 0.75, strata = mis_status)

sba_train <- sba_split |> training() 
sba_test <- sba_split |> testing()

# folding data (resamples) ----
# set seed
set.seed(6051)
sba_folds <-
  sba_train |>
  vfold_cv(v = 10, repeats = 5, strata = mis_status)

# set up controls for fitting resamples----
keep_wflow <- control_resamples(save_workflow = TRUE)

# write out split, train, test and folds----
save(sba_split, file = here("data_splits/sba_split.rda"))
save(sba_train, file = here("data_splits/sba_train.rda"))
save(sba_test, file = here("data_splits/sba_test.rda"))
save(sba_folds, file = here("data_splits/sba_folds.rda"))
save(keep_wflow, file = here("results/keep_wflow.rda"))
