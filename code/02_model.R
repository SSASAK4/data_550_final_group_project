library(tidyverse)
library(broom)
library(here)

here::i_am("code/02_model.R")

covid <- readRDS(here("output", "covid_cleaned.rds"))

model_df <- covid %>%
  select(death_bin, AGE, SEX, hosp_bin, usmer_bin, tobacco_bin, obesity_bin) %>%
  mutate(
    SEX = case_when(
      SEX %in% c(1, "1", "Female", "female") ~ 0,
      SEX %in% c(2, "2", "Male", "male") ~ 1,
      TRUE ~ NA_real_
    ),
    death_bin = as.numeric(death_bin),
    AGE = as.numeric(AGE),
    hosp_bin = as.numeric(hosp_bin),
    usmer_bin = as.numeric(usmer_bin),
    tobacco_bin = as.numeric(tobacco_bin),
    obesity_bin = as.numeric(obesity_bin)
  ) %>%
  drop_na()

table(model_df$SEX, useNA = "ifany")
table(model_df$hosp_bin, useNA = "ifany")
table(model_df$usmer_bin, useNA = "ifany")
table(model_df$tobacco_bin, useNA = "ifany")
table(model_df$obesity_bin, useNA = "ifany")
table(model_df$death_bin, useNA = "ifany")

covid_model <- glm(
  death_bin ~ AGE + SEX + hosp_bin + usmer_bin + tobacco_bin + obesity_bin,
  data = model_df,
  family = binomial(link = "logit")
)

summary(covid_model)

covid_res <- tidy(covid_model, exponentiate = TRUE, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    Predictor = case_when(
      term == "AGE" ~ "Age (per 1-year increase)",
      term == "SEX" ~ "Sex: Male (1) vs Female (0)",
      term == "hosp_bin" ~ "Hospitalized (1) vs Returned Home (0)",
      term == "usmer_bin" ~ "2nd/3rd Level Medical Unit (1) vs 1st Level (0)",
      term == "tobacco_bin" ~ "Tobacco Use (1 vs 0)",
      term == "obesity_bin" ~ "Obesity (1 vs 0)",
      TRUE ~ term
    ),
    OR = round(estimate, 3),
    CI_95 = paste0("(", round(conf.low, 3), " - ", round(conf.high, 3), ")"),
    p_value = ifelse(p.value < 0.001, "<0.001", round(p.value, 3))
  ) %>%
  select(Predictor, OR, CI_95, p_value)

print(covid_res)

saveRDS(model_df, here("output", "model_df.rds"))
saveRDS(covid_model, here("output", "covid_model.rds"))
saveRDS(covid_res, here("output", "covid_res.rds"))