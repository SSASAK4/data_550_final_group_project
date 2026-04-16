library(tidyverse)
library(broom)
library(here)

here::i_am("code/03_logistic_figure.R")

model_df <- readRDS(here("output", "model_df.rds"))
covid_model <- readRDS(here("output", "covid_model.rds"))

# Forest plot
forest_df <- tidy(covid_model, exponentiate = TRUE, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    label = case_when(
      term == "AGE" ~ "Age (per 1-year increase)",
      term == "SEX" ~ "Sex: Male (1) vs Female (0)",
      term == "hosp_bin" ~ "Hospitalized (1) vs Returned Home (0)",
      term == "usmer_bin" ~ "2nd/3rd Level Medical Unit (1) vs 1st Level (0)",
      term == "tobacco_bin" ~ "Tobacco Use (1 vs 0)",
      term == "obesity_bin" ~ "Obesity (1 vs 0)",
      TRUE ~ term
    ),
    label = fct_reorder(label, estimate)
  )

p1 <- ggplot(forest_df, aes(x = estimate, y = label, xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "gray") +
  geom_errorbarh(height = 0.2) +
  geom_point(size = 4, shape = 18, color = "lightblue") +
  geom_text(
    aes(
      x = conf.high * 1.15,
      label = sprintf("%.2f (%.2f-%.2f)", estimate, conf.low, conf.high)
    ),
    hjust = 0, size = 3.2
  ) +
  scale_x_log10() +
  labs(
    title = "Adjusted Odds Ratios for COVID-19 Death",
    x = "Odds Ratio (log scale)",
    y = NULL,
    caption = "Reference: Female (0), returned home (0), 1st-level medical unit (0), no tobacco (0), no obesity (0)."
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.minor = element_blank())

# Marginal effects plot
pred_df <- expand.grid(
  AGE = seq(0, 100, by = 1),
  SEX = c(0, 1),
  hosp_bin = c(0, 1),
  usmer_bin = mean(model_df$usmer_bin),
  tobacco_bin = mean(model_df$tobacco_bin),
  obesity_bin = mean(model_df$obesity_bin)
)

preds <- predict(covid_model, newdata = pred_df, type = "link", se.fit = TRUE)
z <- qnorm(0.975)

pred_df <- pred_df %>%
  mutate(
    prob = plogis(preds$fit),
    lo = plogis(preds$fit - z * preds$se.fit),
    hi = plogis(preds$fit + z * preds$se.fit),
    sex_label = factor(
      ifelse(SEX == 1, "Male", "Female"),
      levels = c("Female", "Male")
    ),
    hosp_label = factor(
      ifelse(hosp_bin == 1, "Hospitalized", "Returned Home"),
      levels = c("Returned Home", "Hospitalized")
    )
  )

p2 <- ggplot(pred_df, aes(x = AGE, y = prob, color = sex_label, fill = sex_label)) +
  geom_ribbon(aes(ymin = lo, ymax = hi), alpha = 0.15, color = NA) +
  geom_line(linewidth = 1.1) +
  facet_wrap(~ hosp_label, scales = "free_y") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_color_manual(
    values = c("Female" = "red", "Male" = "lightblue"),
    name = "Sex"
  ) +
  scale_fill_manual(
    values = c("Female" = "red", "Male" = "lightblue"),
    name = "Sex"
  ) +
  labs(
    title = "Predicted Probability of COVID-19 Death by Age, Sex, and Hospitalization",
    x = "Age (years)",
    y = "Predicted Probability of Death",
    caption = "Other predictors held at sample means. Shaded bands show 95% confidence intervals."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    strip.text = element_text(face = "bold", size = 11),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    plot.caption = element_text(color = "gray50", size = 8)
  )

# Save plots
ggsave(
  here("output", "forest_plot.png"),
  plot = p1, width = 10, height = 5.5, dpi = 150
)

ggsave(
  here("output", "marginal_effects.png"),
  plot = p2, width = 10, height = 5, dpi = 150
)