#' Include in the DOM to provide supporting dependencies for this package
#'
#' @return \code{None} Attaches dependency to the DOM
#' @export
#'
useDTExtend <- function() {
  shiny::tagList(
    htmltools::htmlDependency(
      name = "DTExtend",
      version = utils::packageVersion("DTExtend"),
      package = "DTExtend",
      src = "srcjs",
      script = list(src = "dtextend.min.js")
    )
  )
}
