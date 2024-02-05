# Data cleaning
# Deal with missing values

# loading packages and data
library(tidyverse)
library(here)
sba <- read_rds(here("data/sba.rds"))

# Checking the target variable
sba |>
  skimr::skim_without_charts(mis_status)

# Bar plot for mis_status
mis_status_plot <- sba |>
  ggplot(aes(x = mis_status)) +
  geom_bar(fill = "darkblue", color = "darkblue") +
  labs(title = "Figure 1: Exploring the target variable",
       x = "Loan status",
       y = "Count") +
  scale_x_discrete(labels = c("CHGOFF" = "Charged Off", "P I F" = "Paid in Full")) +
  theme_minimal()

ggsave(here("plots/mis_status_plot.png"), miss_status_plot)

