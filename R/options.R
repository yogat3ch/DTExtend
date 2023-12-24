#' @title Update datatable options
#'
#' @param x \code{datatable}
#' @param options \code{(list)} of options to replace
#'
#' @return \code{datatable}
#' @export

DT_options_update <- function(x, options, hide_cols) {
  out <- x

  if (missing(options))
    options <- out$x$options
  if (!missing(hide_cols))
    options <- append(options, list(columnDefs = list(
      list(
        visible = FALSE,
        targets = UU::which_cols(hide_cols, x$x$data) - 1 # js numbers start with 0
      )
    )))
  if (UU::is_legit(out$x$options$columnDefs) &&
      UU::is_legit(options$columnDefs)) {
    out$x$options$columnDefs <-
      append(out$x$options$columnDefs, options$columnDefs)
    options$columnDefs <- NULL
  }
  if (UU::is_legit(options))
    out$x$options <- purrr::list_modify(out$x$options,!!!options)

  out
}

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
