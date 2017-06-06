library(dplyr)
library(broom)
library(ggplot2)
library(tidyr)

#-----
# Simulation from Section 2
#-----

set.seed(20170601)
n_row <- 100
n_col <- 51
X <- matrix(rnorm(n_row * n_col), n_row, n_col)
colnames(X) <- paste0("X", 1:n_col)
X_df <- as_data_frame(X)

#--- first analysis

full_model <- lm(X51 ~ . + 0, X_df)
glance(full_model)
#   r.squared adj.r.squared     sigma statistic    p.value df    logLik      AIC      BIC deviance
# 1 0.6095064     0.2190127 0.8501273  1.560861 0.05938737 50 -90.99957 283.9991 416.8628 36.13582
#   df.residual
# 1          50
tidy(full_model) %>% tbl_df() %>% filter(p.value < 0.25) %>%
  summarize(significant_at_0.25 = n()) %>% as.integer()
# [1] 17
tidy(full_model) %>% tbl_df() %>% filter(p.value < 0.05) %>%
  summarize(significant_at_0.05 = n()) %>% as.integer()
# [1] 6

#--- second analysis

significant_at_0.25 <- tidy(full_model) %>% tbl_df() %>% filter(p.value < 0.25) %>% select(term)
X_significant <- select(X_df, one_of(unlist(significant_at_0.25)), X51)
model_fit_with_data_reuse <- lm(X51 ~ . + 0, X_significant)
glance(model_fit_with_data_reuse)
#   r.squared adj.r.squared     sigma statistic      p.value df   logLik     AIC      BIC deviance
# 1 0.4862481     0.3810218 0.7568322  4.620976 1.087103e-06 17 -104.716 245.432 292.3251 47.54199
#   df.residual
# 1          83
tidy(model_fit_with_data_reuse) %>% tbl_df() %>% filter(p.value < 0.25) %>%
  summarize(significant_at_0.25 = n()) %>% as.integer()
# [1] 17
tidy(model_fit_with_data_reuse) %>% tbl_df() %>% filter(p.value < 0.05) %>%
  summarize(significant_at_0.05 = n()) %>% as.integer()
# [1] 12
tidy(model_fit_with_data_reuse)

#-----
# Check Freedman's asymptotics results
#-----

set.seed(20170605)
n_row <- 100
n_col <- 51
n_rep <- 1000

X <- matrix(rnorm(n_rep * n_row * n_col), n_rep * n_row, n_col)
colnames(X) <- paste0("X", 1:n_col)
X_df <- as_data_frame(X) %>% mutate(repetition = rep(1:n_rep, each = n_row))

models_df = X_df %>% group_by(repetition) %>%
  do(full_model = lm(X51 ~ . + 0, data = select(., -repetition)))

model_coefs <- tidy(models_df, full_model)
model_statistics <- glance(models_df, full_model)
model_statistics$data_reuse <- rep(FALSE, nrow(model_statistics))

reduced_models <- list()
for (i in 1:n_rep) {
  full_data <- X_df %>% filter(repetition == i)
  significant_coefs <- model_coefs %>% filter(repetition == i) %>% filter(p.value < 0.25)
  reduced_data <- select(full_data, one_of(unlist(significant_coefs[ , "term"])), X51)
  reduced_models[[i]] <- lm(X51 ~ . + 0, data = reduced_data)
  tmp_df = glance(reduced_models[[i]])
  tmp_df$repetition <- i
  tmp_df$data_reuse <- TRUE
  model_statistics <- bind_rows(model_statistics, tmp_df)
}

model_statistics %>%
  select(r.squared, p.value, statistic, repetition, data_reuse) %>%
  mutate(data_reuse = ifelse(data_reuse, "With Data Reuse", "Without Data Reuse")) %>%
  mutate(data_reuse = factor(data_reuse, levels = c("Without Data Reuse", "With Data Reuse"),
                             ordered = TRUE)) %>%
  rename("F-statistic" = statistic, "p-value" = p.value, "R squared" = r.squared) %>%
  gather(stat, value, -repetition, -data_reuse) %>%
  ggplot(aes(x = stat, y = value)) +
    geom_violin(aes(fill = stat), scale = "width", draw_quantiles = c(0.25, 0.5, 0.75)) +
    geom_hline(yintercept = 0.05, linetype = 2, size = 0.3) +
    facet_wrap(~data_reuse) +
    theme_linedraw() +
    scale_y_continuous(breaks = c(0.05, 2, 4, 6)) +
    ggtitle(paste(n_rep, "repetitions of an LM fit with", n_row, "rows,", n_col, "columns"))

ggsave("unnamed-chunk-5-1.png")
