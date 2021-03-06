context("ggeffects, glmmTMB")

library(ggeffects)

# glmmTMB ----

library(glmmTMB)
data(Owls)

m1 <- glmmTMB(SiblingNegotiation ~ SexParent + ArrivalTime + (1 | Nest), data = Owls, family = nbinom1)
m2 <- glmmTMB(SiblingNegotiation ~ SexParent + ArrivalTime + (1 | Nest), data = Owls, family = nbinom2)
m4 <- glmmTMB(SiblingNegotiation ~ FoodTreatment + ArrivalTime + SexParent + (1 | Nest), data = Owls, ziformula =  ~ 1, family = truncated_poisson(link = "log"))

test_that("ggpredict, glmmTMB", {
  ggpredict(m1, c("ArrivalTime", "SexParent"))
  ggpredict(m2, c("ArrivalTime", "SexParent"))
  ggpredict(m4, c("FoodTreatment", "ArrivalTime [21,24,30]", "SexParent"))
  ggpredict(m1, c("ArrivalTime", "SexParent"), type = "re")
  ggpredict(m2, c("ArrivalTime", "SexParent"), type = "re")
  ggpredict(m4, c("FoodTreatment", "ArrivalTime [21,24,30]", "SexParent"), type = "re")
})
