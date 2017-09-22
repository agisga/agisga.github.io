sleep_for_a_minute <- function() { Sys.sleep(60) }

#---

start_time <- Sys.time()
sleep_for_a_minute()
end_time <- Sys.time()

end_time - start_time
# Time difference of 1.000327 mins

#---

system.time({ sleep_for_a_minute() })
#   user  system elapsed
#  0.004   0.000  60.051

#---

devtools::install_github("eddelbuettel/rbenchmark")

library(rbenchmark)

benchmark("lm" = {
            X <- matrix(rnorm(1000), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- lm(y ~ X + 0)$coef
          },
          "pseudoinverse" = {
            X <- matrix(rnorm(1000), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- solve(t(X) %*% X) %*% t(X) %*% y
          },
          "linear system" = {
            X <- matrix(rnorm(1000), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- solve(t(X) %*% X, t(X) %*% y)
          },
          replications = 1000,
          columns = c("test", "replications", "elapsed",
                      "relative", "user.self", "sys.self"))

#            test replications elapsed relative user.self sys.self
# 3 linear system         1000   0.167    1.000     0.208    0.240
# 1            lm         1000   0.930    5.569     0.952    0.212
# 2 pseudoinverse         1000   0.240    1.437     0.332    0.612

#---

devtools::install_github("olafmersmann/microbenchmarkCore")
devtools::install_github("olafmersmann/microbenchmark")

library(microbenchmark)

set.seed(2017)
n <- 10000
p <- 100
X <- matrix(rnorm(n*p), n, p)
y <- X %*% rnorm(p) + rnorm(100)

check_for_equal_coefs <- function(values) {
  tol <- 1e-12
  max_error <- max(c(abs(values[[1]] - values[[2]]),
                     abs(values[[2]] - values[[3]]),
                     abs(values[[1]] - values[[3]])))
  max_error < tol
}

mbm <- microbenchmark("lm" = { b <- lm(y ~ X + 0)$coef },
               "pseudoinverse" = {
                 b <- solve(t(X) %*% X) %*% t(X) %*% y
               },
               "linear system" = {
                 b <- solve(t(X) %*% X, t(X) %*% y)
               },
               check = check_for_equal_coefs)

mbm
# Unit: milliseconds
#           expr      min        lq      mean    median        uq      max neval cld
#             lm 96.12717 124.43298 150.72674 135.12729 188.32154 236.4910   100   c
#  pseudoinverse 26.61816  28.81151  53.32246  30.69587  80.61303 145.0489   100  b
#  linear system 16.70331  18.58778  35.14599  19.48467  22.69537 138.6660   100 a

library(ggplot2)
autoplot(mbm)
ggsave("mbm.png", width = 3, height = 2)

#---

devtools::install_github("collectivemedia/tictoc")

library(tictoc)

tic("sleeping")
print("falling asleep...")
sleep_for_a_minute()
print("...waking up")
toc()
# [1] "falling asleep..."
# [1] "...waking up"
# sleeping: 60.026 sec elapsed

tic("total")
tic("data generation")
X <- matrix(rnorm(50000*1000), 50000, 1000)
b <- sample(1:1000, 1000)
y <- runif(1) + X %*% b + rnorm(50000)
toc()
tic("model fitting")
model <- lm(y ~ X)
toc()
toc()
# data generation: 3.792 sec elapsed
# model fitting: 39.278 sec elapsed
# total: 43.071 sec elapsed
