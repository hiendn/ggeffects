#' @title Get marginal effects for model response
#' @name emm
#'
#' @description \code{emm()} is a convenient shortcut to compute the estimated
#'              marginal mean, resp. the marginal effect of the model's response
#'              variable, with all independent variables held constant (at
#'              their \code{\link[sjstats]{typical_value}}).
#'
#' @inheritParams ggpredict
#'
#' @return A tibble with the marginal effect of the response (\code{predicted})
#'         and the confidence intervals \code{conf.low} and \code{conf.high}.
#'         For \code{polr}-objects, the marginal effect for each level of the
#'         response variable is returned.
#'
#' @details For linear models, the predicted value is the estimated marginal
#'          mean. Else, the predicted value is on the scale of the inverse of
#'          link function.
#'
#'
#' @examples
#' data(efc)
#' fit <- lm(barthtot ~ c12hour + neg_c_7 + c161sex + c172code, data = efc)
#' emm(fit)
#'
#' # Example from ?MASS::polr
#' library(MASS)
#' options(contrasts = c("contr.treatment", "contr.poly"))
#' house.plr <- polr(Sat ~ Infl + Type + Cont, weights = Freq, data = housing)
#' emm(house.plr)
#'
#' @importFrom sjstats typical_value pred_vars model_frame model_family
#' @importFrom dplyr select
#' @importFrom purrr map_df
#' @importFrom tidyselect one_of
#' @export
emm <- function(model, ci.lvl = .95, type = c("fe", "re"), typical = "mean", ...) {
  # match arguments
  type <- match.arg(type)

  # get model frame
  fitfram <- sjstats::model_frame(model, fe.only = FALSE)

  # create data frame
  newdat <- purrr::map_df(fitfram, ~ sjstats::typical_value(.x, fun = typical))

  # check class of fitted model
  fun <- get_predict_function(model)
  # check model family, do we have count model?
  faminfo <- sjstats::model_family(model)

  # find additional tweak arguments
  prettify.at <- 25
  add.args <- lapply(match.call(expand.dots = F)$`...`, function(x) x)
  if ("prettify.at" %in% names(add.args)) prettify.at <- eval(add.args[["prettify.at"]])

  # compute predictions here
  preds <-
    select_prediction_method(
      fun,
      model,
      newdat,
      ci.lvl,
      type,
      faminfo,
      ppd = FALSE,
      terms = sjstats::pred_vars(model),
      typical,
      prettify = TRUE,
      prettify.at = prettify.at,
      ...
    )

  suppressWarnings(
    dplyr::select(preds, tidyselect::one_of("predicted", "conf.low", "conf.high", "response.level"))
  )
}
