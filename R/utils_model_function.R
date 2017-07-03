#' @importFrom dplyr case_when
get_model_function <- function(model) {
  # check class of fitted model
  dplyr::case_when(
    inherits(model, "lrm") ~ "glm",
    inherits(model, "svyglm.nb") ~ "glm",
    inherits(model, "svyglm") ~ "glm",
    inherits(model, "glmmTMB") ~ "glm",
    inherits(model, "negbin") ~ "glm",
    inherits(model, "gam") ~ "glm",
    inherits(model, "vgam") ~ "glm",
    inherits(model, "vglm") ~ "glm",
    inherits(model, "glm") ~ "glm",
    inherits(model, "gls") ~ "lm",
    inherits(model, "gee") ~ "lm",
    inherits(model, "plm") ~ "lm",
    inherits(model, "lm") ~ "lm",
    inherits(model, "lme") ~ "lm",
    inherits(model, "glmerMod") ~ "glm",
    inherits(model, "nlmerMod") ~ "lm",
    inherits(model, c("lmerMod", "merModLmerTest")) ~ "lm",
    TRUE ~ "glm"
  )
}

#' @importFrom dplyr case_when
get_predict_function <- function(model) {
  # check class of fitted model
  dplyr::case_when(
    inherits(model, "lrm") ~ "lrm",
    inherits(model, "svyglm.nb") ~ "svyglm.nb",
    inherits(model, "svyglm") ~ "svyglm",
    inherits(model, "gam") ~ "gam",
    inherits(model, "glmerMod") ~ "glmer",
    inherits(model, "glmmTMB") ~ "glmmTMB",
    inherits(model, "nlmerMod") ~ "nlmer",
    inherits(model, c("lmerMod", "merModLmerTest")) ~ "lmer",
    inherits(model, "lme") ~ "lme",
    inherits(model, "gls") ~ "gls",
    inherits(model, "gee") ~ "gee",
    inherits(model, "plm") ~ "plm",
    inherits(model, "negbin") ~ "glm.nb",
    inherits(model, "vgam") ~ "vgam",
    inherits(model, "vglm") ~ "vglm",
    inherits(model, "glm") ~ "glm",
    inherits(model, "lm") ~ "lm",
    TRUE ~ "generic"
  )
}