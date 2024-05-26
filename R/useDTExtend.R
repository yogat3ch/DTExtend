#' Include in the DOM to provide supporting dependencies for this package
#'
#' @param use_tippy \code{lgl} Whether to use the Tippy package if using `DT_header_tooltips`
#' @return \code{None} Attaches dependency to the DOM
#' @export
#'
useDTExtend <- function(use_tippy = FALSE) {
  shiny::tagList(
    htmltools::htmlDependency(
      name = "DTExtend",
      version = utils::packageVersion("DTExtend"),
      package = "DTExtend",
      src = "srcjs",
      script = list(src = "dtextend.min.js"),
      if (use_tippy) tippy::useTippy(),
    )
  )
}
