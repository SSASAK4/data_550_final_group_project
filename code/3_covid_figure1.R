library(dplyr)
library(ggplot2)

here::i_am("code/3_covid_figure1.R")

data <- readRDS(
  file = here::here("output", "covid_cleaned.rds")
)

data <- data%>%
  mutate(
    age_group = case_when(
      AGE < 18 ~ "<18",
      AGE >= 18 & AGE < 40 ~ "18-39",
      AGE >= 40 & AGE < 65 ~ "40-64",
      AGE >= 65 ~ "65+"
    ),
    SEX = as.factor(SEX),
    covid_binary = covid_positive_bin   
  )

plot_data <- data %>%
  group_by(age_group, SEX, covid_binary) %>%
  summarise(n = n(), .groups = "drop")

plot <- ggplot(plot_data, aes(x = age_group, y = n, fill = factor(covid_binary))) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~SEX) +
  labs(
    title = "COVID-19 Cases by Age Group and Sex",
    x = "Age Group",
    y = "Count",
    fill = "COVID Status"
  ) +
  scale_fill_manual(
    values = c("#B0B0B0", "#E64B35"),
    labels = c("Negative / Inconclusive", "Positive")
  ) +
  theme_minimal()

saveRDS(
  plot,
  file = here::here("output/figure1.rds")
)

