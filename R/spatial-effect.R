#' Compute spatial effect
#'
#' Computes the effect of plate position on colony growth.
#'
#' @param x Integer vector - x colony position (e.g. column).
#' @param y Integer vector - y colony position (e.g. row).
#' @param value Numeric vector - measured colony size.
#' @param method Method used for fitting smooth surface. Either \code{'rlm'},
#' or \code{'loess'}. Defaults to \code{'rlm'}.
#' @param deg Degree of polynomial used for fitting. See \link[stats]{poly} for
#' details. Defaults to 2.
#' @param ... Further arguments passed to method.
#'
#' @seealso \code{\link[MASS]{rlm}} \code{\link[stats]{loess}}
#'
#' @return Returns a vector with the same length as \code{value}.
#'
#' @importFrom MASS rlm
#' @export

spatial_effect <- function(x, y, value, method = c('rlm', 'loess'), deg = 2, ...) {
  # Check input
  assert_that(is.number(deg))
  if (!method[1] %in% c('rlm', 'loess')) stop('Unknown method.')

  # Combine and clean data
  data  <- data_frame(x = x, y = y, value = value)
  clean <- filter(data, is.finite(value))

  # Fit a smooth surface
  if (method[1] == 'rlm') {
    model <- rlm(value ~ poly(x, y, degree = deg), data = clean, ...)
    return(predict(model, data))
  }

  if (method[1] == 'loess') {
    # x and y should be on a common scale, therefore do not normalize
    model <- loess(value ~ row + col, data = data, degree = deg, normalize = FALSE, ...)
    return(predict(model, data))
  }
}
