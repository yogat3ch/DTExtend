
#' Create DT formatted filter statements from a list of filter ranges
#'
#' @param filters \code{named list} With names corresponding to data column names and numeric ranges (length 2 numeric vector) or character values to be applied to each column
#' @param nms \code{chr} Names of each column in the data
#'
#' @return \code{chr} of DT formatted filter statements
#' @export
#'
#' @examples
#' DT_filter_chr(list(`LB Pol Short Freq` = c(65, 67), `Policy ID` = "00"), c("Policy ID", default_choices$performance))
DT_filter_chr <- function(filters, nms) {
  out <- rep("", length(nms))
  if (!rlang::is_empty(filters)) {
    f <- purrr::map_chr(filters, \(.x) if (is.numeric(.x)) paste(.x, collapse = "...") else .x)
    out[match(names(f), nms)] <- f
  }
  out
}

#' Transforms the DT search_columns input into the `searchCols` option list
#' @description
#' **IMPORTANT** Only use on DT where the data will not change!
#' For an explanation of how this option must be formatted, see this [comment](https://github.com/rstudio/DT/issues/77#issuecomment-107257008).
#'
#' @param search_columns \code{chr} The value stored in input$[outputId]_search_columns
#'
#' @return \code{list} A list object ready for use in Datatable options argument
#' @export
#'

DT_filter_restore <- function(search_columns = session$input[[paste0(outputId, "_search_columns")]], outputId, session = shiny::getDefaultReactiveDomain()) {
  search_columns <- isolate(search_columns)
  if (!is.null(search_columns) && any(!UU::zchar(search_columns))) {
    purrr::map(search_columns, \(.x) {
      out <- UU::`%|zchar|%`(.x, NULL)[[1]]
      if (!is.null(out[[1]]))
        out <- list(search = .x)
      out
    })
  }
}
