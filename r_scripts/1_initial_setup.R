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

# quick data quality ----

# initial split ----
# set seed
set.seed(3012)

# folding data (resamples) ----
# set seed 
set.seed(605)

# set up controls for fitting resamples ----


# write out split, train, test and folds ----
