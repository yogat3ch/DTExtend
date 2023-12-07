
#' @title Format numbers in a datatable
#' @description
#' Format datatable numeric values with commas and no decimal places
#'
#' @inherit DT::formatCurrency params return examples
#'
#' @export
#'

DT_formatNum <-
  function(table,
           columns = names(purrr::keep(table$x$data, is.numeric)),
           currency = "",
           interval = 3,
           mark = ",",
           digits = 0,
           dec.mark = getOption("OutDec"),
           before = TRUE,
           zero.print = NULL,
           rows = NULL) {

    DT::formatCurrency(
      table = table,
      columns = columns,
      currency = currency,
      interval = interval,
      mark = mark,
      digits = digits,
      dec.mark = dec.mark,
      before = before,
      zero.print = zero.print,
      rows = rows
    )
  }
