#' Add Tippy tooltips to headers
#' @description
#' (Requires \code{\href{https://github.com/JohnCoene/tippy}{tippy}} or \code{\href{https://atomiks.github.io/tippyjs/v6/getting-started/}{tippyjs}} dependencies in the DOM)
#'
#' @param id \code{chr} ID of the DT output to tippy the headers
#' @param col_nms \code{chr} Column names exactly as displayed on the rendered DT
#' @param tooltips \code{chr} content of the tooltips, currently only character strings supported. Make an issue if you would like to see HTML supported
#' @param calls_only \code{lgl} whether just to return the tippy calls, to be called with \code{\link[shinyjs]{runjs}}
#' @param .ns \code{fun} The ns function
#' @param asis \code{lgl} Whether the `id` should be used asis, or automatically namespaced.
#'
#' @return \code{chr} JS Code to be passed to `DTExtend::DT_callback`
#' @export
#' @examples
#' # To be used in combination with `DT_callback`. Tooltips can be bound to the rendered event with shinyjs
#' \dontrun{
#' observeEvent(input$[DTOutputId]_rendered, {
#'    shinyjs::runjs(
#'      DTExtend::DT_header_tooltips(
#'        id = "policy_choices",
#'        col_nms = c("[Column names here]"),
#'        calls_only = TRUE)
#'      )
#'    })
#' }

DT_header_tooltips <- function(id, col_nms, tooltips = col_nms, calls_only = FALSE, .ns = shinyVirga::ns_find(), asis = FALSE) {
  if (!asis)
    id <- .ns(id)
  if (!identical(length(col_nms), length(tooltips))) {
    UU::gbort("`tooltips` must be the same length as `col_nms`")
  }
  tippy_calls <- purrr::map2(glue::glue("#{id} th[aria-label='{col_nms}: activate to sort column descending']"), tooltips, \(.x, .y) {
    UU::glue_js(
      "tippy(\"*{.x}*\", {\n
                content: \"*{.y}*\"\n
              })"
    )
  }) |>
    glue::glue_collapse(sep = ";\n")
  if (!calls_only) {
    tippy_calls <- paste0(
      "table.on('draw.dt', () => {\n",
      tippy_calls,
      "\n})"
    )
  }
  return(tippy_calls)
}
