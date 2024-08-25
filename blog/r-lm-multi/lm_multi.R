library(tidyverse)
theme_set(theme_test())

# get data
d <- ISLR::Wage
d

# model
m <- lm(wage ~ age + year + jobclass + education, d)
m
summary(m)

# assumptions
performance::check_model(m)

# predictions
ggeffects::ggeffect(m) %>% 
    plot() %>% 
    sjPlot::plot_grid()

# contrast
gtsummary::tbl_regression(m, add_pairwise_contrasts = TRUE)

# model equation
equatiomatic::extract_eq(m)
