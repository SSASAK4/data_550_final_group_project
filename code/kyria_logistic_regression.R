# Title: DATA 550 Midterm Project Code
# Author: Kyria Santa
# Predictors: Diabetes, Hypertension, COPD, Age, Sex
# Outcome: Intubation
# Date: 04/15/2026

# Install and Load Packages 
library(tidyverse)
library(broom)

# Load the Dataset
df <- read.csv("covid_sub.csv")

# Data Cleaning and Recoding
# Need numeric 0/1 instead of Yes/No
df_clean <- df %>%
  mutate(
    # Outcome: Intubed
    INTUBED = ifelse(INTUBED == "Yes", 1,
                     ifelse(INTUBED == "No", 0, NA)),
    
    # Predictors: Comorbidities
    DIABETES = ifelse(DIABETES == "Yes", 1, 0),
    HIPERTENSION = ifelse(HIPERTENSION == "Yes", 1, 0),
    COPD = ifelse(COPD == "Yes", 1, 0),
    
    # Demographics
    SEX = ifelse(SEX == "female", 1,
                 ifelse(SEX == "male", 0, NA)), # 1 = Female, 0 = Male
    AGE = as.numeric(AGE)
  ) %>%
  
  # Remove missing rows
  filter(!is.na(INTUBED))

# Run Logistic Regression
model <- glm(
  INTUBED ~ DIABETES + HIPERTENSION + COPD + AGE + SEX,
  data = df_clean,
  family = binomial(link = "logit")
)
summary(model)

# Odds Ratios (ORs) and Confidence Intervals (CIs)
model_results <- tidy(model, exponentiate = TRUE, conf.int = TRUE)

model_results

# Plots
model_results <- model_results %>%
  filter(term != "(Intercept)") %>%
  mutate(term = recode(term,
        DIABETES = "Diabetes",
        HIPERTENSION = "Hypertension",
        COPD = "COPD",
        AGE = "Age",
        SEX = "Sex (Female)"
  ))

ggplot(model_results, aes(x = term, y = estimate)) +
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

# Checking sex variable
table(df$SEX, useNA = "ifany")



