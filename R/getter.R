#' @title Get titles and labels from data
#' @name get_title
#'
#' @description Get variable and value labels from \code{ggeffects}-objects. Functions
#'              like \code{ggpredict()} or \code{gginteraction()} save
#'              information on variable names and value labels as additional attributes
#'              in the returned data frame. This is especially helpful for labelled
#'              data (see \CRANpkg{sjlabelled}), since these labels can be used to
#'              set axis labels and titles.
#'
#' @param x An object of class \code{ggeffects}, as returned by any ggeffects-function;
#'          for \code{get_complete_df()}, must be a list of \code{ggeffects}-objects.
#' @param case Desired target case. Labels will automatically converted into the
#'          specified character case. See \code{\link[sjlabelled]{convert_case}} for
#'          more details on this argument.
#'
#' @return The titles or labels as character string, or \code{NULL}, if variables
#'         had no labels; \code{get_complete_df()} returns the input list \code{x}
#'         as single data frame, where the grouping variable indicates the
#'         marginal effects for each term.
#'
#' @examples
#' data(efc)
#' efc$c172code <- sjmisc::to_factor(efc$c172code)
#' fit <- lm(barthtot ~ c12hour + neg_c_7 + c161sex + c172code, data = efc)
#'
#' mydf <- ggpredict(fit, terms = c("c12hour", "c161sex", "c172code"))
#'
#' library(ggplot2)
#' ggplot(mydf, aes(x = x, y = predicted, colour = group)) +
#'   stat_smooth(method = "lm") +
#'   facet_wrap(~facet, ncol = 2) +
#'   labs(
#'     x = get_x_title(mydf),
#'     y = get_y_title(mydf),
#'     colour = get_legend_title(mydf)
#'   )
#'
#' # get marginal effects, a list of tibbles (one tibble per term)
#' eff <- ggalleffects(fit)
#' eff
#' get_complete_df(eff)
#'
#' # get marginal effects for education only, and get x-axis-labels
#' mydat <- eff[["c172code"]]
#' ggplot(mydat, aes(x = x, y = predicted, group = group)) +
#'   stat_summary(fun.y = sum, geom = "line") +
#'   scale_x_discrete(labels = get_x_labels(mydat))
#'
#' @export
get_title <- function(x, case = NULL) {
  if (sjmisc::is_empty(x)) return(NULL)

  if (!inherits(x, "ggeffects"))
    stop("`x` must be of class `ggeffects`.", call. = F)

  sjlabelled::convert_case(attr(x, which = "title", exact = T), case)
}


#' @rdname get_title
#' @export
get_x_title <- function(x, case = NULL) {
  if (sjmisc::is_empty(x)) return(NULL)

  if (!inherits(x, "ggeffects"))
    stop("`x` must be of class `ggeffects`.", call. = F)

  sjlabelled::convert_case(attr(x, which = "x.title", exact = T), case)
}


#' @rdname get_title
#' @export
get_y_title <- function(x, case = NULL) {
  if (sjmisc::is_empty(x)) return(NULL)

  if (!inherits(x, "ggeffects"))
    stop("`x` must be of class `ggeffects`.", call. = F)

  sjlabelled::convert_case(attr(x, which = "y.title", exact = T), case)
}


#' @rdname get_title
#' @export
get_legend_title <- function(x, case = NULL) {
  if (sjmisc::is_empty(x)) return(NULL)

  if (!inherits(x, "ggeffects"))
    stop("`x` must be of class `ggeffects`.", call. = F)

  sjlabelled::convert_case(attr(x, which = "legend.title", exact = T), case)
}


#' @rdname get_title
#' @export
get_legend_labels <- function(x, case = NULL) {
  if (sjmisc::is_empty(x)) return(NULL)

  if (!inherits(x, "ggeffects"))
    stop("`x` must be of class `ggeffects`.", call. = F)

  sjlabelled::convert_case(attr(x, which = "legend.labels", exact = T), case)
}


#' @rdname get_title
#' @export
get_x_labels <- function(x, case = NULL) {
  if (sjmisc::is_empty(x)) return(NULL)

  if (!inherits(x, "ggeffects"))
    stop("`x` must be of class `ggeffects`.", call. = F)

  sjlabelled::convert_case(attr(x, which = "x.axis.labels", exact = T), case)
}


#' @rdname get_title
#' @importFrom sjlabelled as_numeric
#' @importFrom dplyr bind_rows
#' @export
get_complete_df <- function(x, case = NULL) {
  suppressWarnings(dplyr::bind_rows(lapply(x, function(df) {
    df$x <- sjlabelled::as_numeric(df$x)
    df
  })))
}
