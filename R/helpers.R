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
