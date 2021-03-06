stopifnot(require("testthat"),
          require("ggeffects"),
          require("lme4"),
          require("sjlabelled"),
          require("sjmisc"))

context("ggeffects, lmer")

# lmer ----

data(efc)
efc$grp = to_label(efc$e15relat)
fit <- lmer(neg_c_7 ~ c12hour + e42dep + c161sex + c172code + (1|grp), data = efc)

test_that("ggpredict, lmer", {
  ggpredict(fit, "c12hour")
  ggpredict(fit, c("c12hour", "c161sex"))
  ggpredict(fit, c("c12hour", "c161sex", "c172code"))
  ggpredict(fit, "c12hour", type = "re")
  ggpredict(fit, c("c12hour", "c161sex"), type = "re")
  ggpredict(fit, c("c12hour", "c161sex", "c172code"), type = "re")
})

test_that("ggaverage, lmer", {
  ggaverage(fit, "c12hour")
  ggaverage(fit, c("c12hour", "c161sex"))
  ggaverage(fit, c("c12hour", "c161sex", "c172code"))
})

test_that("ggalleffects, lmer", {
  ggalleffects(fit, "c12hour")
  ggalleffects(fit, c("c12hour", "c161sex"))
  ggalleffects(fit, c("c12hour", "c161sex", "c172code"))
  ggalleffects(fit)
})

test_that("ggeffect, lmer", {
  ggeffect(fit, "c12hour")
  ggeffect(fit, c("c12hour", "c161sex"))
  ggeffect(fit, c("c12hour", "c161sex", "c172code"))
})
