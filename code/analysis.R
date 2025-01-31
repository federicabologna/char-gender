library(tidyverse)

clean <- read_csv("../data/clean_recent.csv")

## A = Character gender in hike story, Y = Chose hike story


# PARAMETRIC 1
pi <- clean |>
  group_by(hike_woman, respondent_woman) |>
  summarize(
    # proportion choosing the hiking story
    pi_estimate = mean(chose_hike),
    # sampling variance of that proportion
    pi_var = mean(chose_hike) * (1 - mean(chose_hike)) / n(),
    cases = n(),
    .groups = "drop"
  ) |>
  print()

subgroup_effects <- pi |>
  pivot_longer(cols = c('pi_estimate', 'pi_var', 'cases')) |>
  unite("quantity",c("name","hike_woman")) |>
  pivot_wider(names_from = "quantity", values_from = "value") |>
  mutate(
    effect = pi_estimate_1 - pi_estimate_0,
    effect_var = pi_var_1 + pi_var_0,
    effect_se = sqrt(effect_var),
    ci.min = effect - qnorm(.975) * effect_se,
    ci.max = effect + qnorm(.975) * effect_se,
    cases = cases_0 + cases_1
    ) |>
    select(respondent_woman, effect, effect_se, effect_var, ci.min, ci.max, cases) |>
    print()

average_effect <- subgroup_effects |>
  select(effect,cases) |>
  mutate(
    av_effect = weighted.mean(effect, w = cases),
    total = sum(cases),
    av_effect_var = av_effect * (1 - av_effect) / total,
    av_effect_se = sqrt(av_effect_var),
    ci.min = av_effect - qnorm(.975) * av_effect_se,
    ci.max = av_effect + qnorm(.975) * av_effect_se
    ) |>
  select(av_effect,
         av_effect_var,
         av_effect_se,
         ci.min,
         ci.max) |>
  slice(-1) |>
  print()

average_effect2 <- subgroup_effects |>
  select(effect,cases) |>
  mutate(
    av_effect = weighted.mean(effect, w = cases),
    total = sum(cases),
    av_effect_sd = sqrt(av_effect * (1 - av_effect)),
    ci.min = av_effect - 1.96 * av_effect_sd/sqrt(total),
    ci.max = av_effect +  1.96 * av_effect_sd/sqrt(total)
  ) |>
  select(av_effect,
         av_effect_sd,
         ci.min,
         ci.max) |>
  slice(-1) |>
  print()


# PARAMETRIC 2
ybar1 <- clean |>
  filter(hike_woman == 1) |>
  group_by(respondent_woman) |>
  summarize(cases1 = n(),
            ybar1 = mean(chose_hike),
            .groups = "drop")

ybar0 <- clean |>
  filter(hike_woman == 0) |>
  group_by(respondent_woman) |>
  summarize(cases0 = n(),
            ybar0 = mean(chose_hike),
            .groups = "drop")

cate <- ybar1 |>
  full_join(ybar0, by = c("respondent_woman")) |>
  mutate(cases = cases0 + cases1,
         effect = ybar1 - ybar0)

average_effect_estimate <- cate %>%
  ungroup() %>%
  summarize(average_effect = weighted.mean(effect, w = cases),
            .groups = "drop")



## A = Respondent gender, Y = Chose woman

# PARAMETRIC 1
ybar1 <- clean |>
  filter(respondent_woman == 1) |>
  summarize(cases1 = n(),
            ybar1 = mean(chose_woman),
            .groups = "drop")

ybar0 <- clean |>
  filter(respondent_woman == 0) |>
  summarize(cases0 = n(),
            ybar0 = mean(chose_woman),
            .groups = "drop")

cate <- ybar1 |>
  cross_join(ybar0) |>
  mutate(cases = cases0 + cases1,
         effect = ybar1 - ybar0)

# PARAMETRIC 2
pi <- clean |>
  group_by(respondent_woman) |>
  summarize(
    # proportion choosing the hiking story
    pi_estimate = mean(chose_woman),
    # sampling variance of that proportion
    pi_var = mean(chose_woman) * (1 - mean(chose_woman)) / n(),
    .groups = "drop"
  ) |>
  print()

# NONPARAMETRIC 1
fit <- lm(chose_hike ~ hike_woman, data = clean)

women <- clean |>
  mutate(respondent_woman = 1)

men <- clean |>
  mutate(respondent_woman = 0)


conditional_average_causal_effect <- clean |>
  mutate(yhat_woman = predict(fit, newdata = women),
         yhat_man = predict(fit, newdata = men),
         effect_of_gender = yhat_woman - yhat_man) 

conditional_average_causal_effect |>
  summarize(effect_of_gender = mean(effect_of_gender))
