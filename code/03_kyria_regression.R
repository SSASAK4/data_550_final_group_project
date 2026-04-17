# Title: DATA 550 Final Group Project Code
# Author: Kyria Santa
# Predictors: Diabetes, Hypertension, COPD, Age, Sex
# Outcome: Intubation
# Date: 04/15/2026

# ==========================================
# LOAD PACKAGES
# ==========================================
library(tidyverse)
library(broom)
library(here)

# ==========================================
# LOAD DATA
# ==========================================
here::i_am("code/03_kyria_regression.R")
data <- readRDS(file = here::here("output", "covid_cleaned.rds"))

# ==========================================
# PREPARE DATA
# ==========================================
# Data is already cleaned and recoded from 1_covid_cleaned.R
# Just filter out missing intubation values
df_clean <- data %>%
  filter(!is.na(intubed_bin))

# ==========================================
# RUN LOGISTIC REGRESSION
# ==========================================
model <- glm(
  intubed_bin ~ diabetes_bin + hypertension_bin + copd_bin + AGE + sex,
  data = df_clean,
  family = binomial(link = "logit")
)

print(summary(model))

# ==========================================
# ODDS RATIOS AND CONFIDENCE INTERVALS
# ==========================================
model_results <- tidy(model, exponentiate = TRUE, conf.int = TRUE)
print(model_results)

# ==========================================
# PLOT
# ==========================================
plot_results <- model_results %>%
  filter(term != "(Intercept)") %>%
  mutate(term = recode(term,
                       diabetes_bin     = "Diabetes",
                       hypertension_bin = "Hypertension",
                       copd_bin         = "COPD",
                       AGE              = "Age",
                       sexMale          = "Sex (Male)"
  ))

ggplot(plot_results, aes(x = term, y = estimate)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  geom_hline(yintercept = 1, linetype = "dashed") +
  coord_flip() +
  labs(
    title = "Odds Ratios for Intubation (COVID Patients)",
    x = "Predictor",
    y = "Odds Ratio (95% CI)"
  ) +
  theme_minimal()

# ==========================================
# SAVE OUTPUTS
# ==========================================
ggsave(
  here::here("output", "kyria_intubation_plot.png"),
  width = 8, height = 5, dpi = 150
)

saveRDS(model, file = here::here("output", "kyria_model.rds"))

# ==========================================
# QUALITY CHECK
# ==========================================
print(table(df_clean$sex, useNA = "ifany"))