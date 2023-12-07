#' Determine the index of a column name to hide
#'
#' @param colnames \code{chr} of column names
#' @param names \code{chr} of columns to hide
#'
#' @return \code{list} with DT option to hide values
#' @export
#'

DT_hide_col <- function(colnames, names) {
  pos <- colnames %in% names
  stopifnot(`Names not found in set of colnames` = any(pos))
  list(visible = FALSE, targets = which(pos) - 1)
}
