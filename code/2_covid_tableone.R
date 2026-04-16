library(tidyverse)
library(gtsummary)

here::i_am("code/2_covid_tableone.R")

data <- readRDS(
  file = here::here("output", "covid_cleaned.rds")
)

bin_vars <- c("diabetes_bin", "copd_bin", "asthma_bin",
              "hypertension_bin", "inmsupr_bin", "other_disease_bin",
              "cardiovascular_bin", "obesity_bin", "renal_bin", "tobacco_bin")

covid <- data |>
  mutate(across(all_of(bin_vars),
                ~ na_if(.x, 97) |> na_if(98) |> na_if(99))) |>
  select("AGE", "sex",
         "diabetes_bin", "copd_bin", "asthma_bin",
         "hypertension_bin", "inmsupr_bin", "other_disease_bin",
         "cardiovascular_bin", "obesity_bin", "renal_bin", "tobacco_bin",
         "covid_positive_bin") |>
  na.omit()

table_one <- covid |>
  select("AGE", "sex",
         "diabetes_bin", "copd_bin", "asthma_bin",
         "hypertension_bin", "inmsupr_bin", "other_disease_bin",
         "cardiovascular_bin", "obesity_bin", "renal_bin", "tobacco_bin",
         "covid_positive_bin") |>
  tbl_summary(by = covid_positive_bin) |>
  add_overall() |>
  add_p()

print(table_one)

saveRDS(
  table_one,
  file = here::here("output/table_one.rds")
)