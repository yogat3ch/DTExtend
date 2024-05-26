#' Create a `outputId`_ran input value when a render function rungs
#'
#' @param id \code{chr} outputId
#' @param htmlwidget \code{htmlwidget} if the object is an htmlwidget, the onRender callback can be used to determine when the widget renders
#' @param asis \code{lgl} whether to leave the `id` as-is (no namespacing)
#' @param session \code{env} The Shiny session object
#' @param debugger \code{lgl} Whether to insert a JS debugger statement into the callback
#'
#' @return \code{htmlwidget/none} If `htmlwidget` is provided, an `htmlwidget` with the `onRender` callback added. Otherwise nothing is returned and \link[shinyjs]{runjs} is used internally
#' @export
#'

render_ran_input <- function(id, htmlwidget, asis = FALSE, session = shiny::getDefaultReactiveDomain(), debugger = FALSE) {

  if (!missing(htmlwidget)) {
    htmlwidgets::onRender(
      htmlwidget,
      UU::glue_js(
        c("(e, x) => {",
          "var id = e.id + '_ran';",
          "var val = window[id] || 0;",
          if (debugger) 'debugger;',
          "val += 1;",
          "window[id] = val;",
          "Shiny.setInputValue(id, val, {priority: 'event'});",
          "}")
      )
    )
  } else {
    id_ran <- paste0(id, "_ran")
    val <- shiny::isolate(session$input[[id_ran]] %||% 0)
    if (!asis) {
      id_ran <- session$ns(id_ran)
    }
    shinyjs::runjs(shinyVirga::js_set_input_val(id_ran,  val + 1, asis = TRUE))
  }

}
