
#' Create a call to \link[DT]{styleRow} for matching color to backgroundColor for contrast
#'
#' @inherit DT::styleRow params return
#' @inheritParams UU::color_text_by_luminance
#' @param luminance_threshold \code{num} value between 0 1 as the luminance threshold of the background that shifts the color to a contrasting color
#'
#' @export
#'

DT_style_row_color <- function(rows, values, default = NULL, luminance_threshold = .5, text_dark = "#333", text_light = "#FFF") {
  DT::styleRow(
    rows = rows,
    values = UU::color_text_by_luminance(values, text_dark = text_dark, text_light = text_light),
    default = default
  )
}


#' Style rows of a `datatable` using source_cols/ID
#'
#' @param table \code{datatable}
#' @inheritParams DT::styleRow
#' @inheritParams DT::formatStyle
#' @param color \code{call} to `DT_style_row_color` that uses `rows`, `values` & `default` to impute background and foreground colors based on luminance.
#' @inheritDotParams DT::formatStyle
#'
#' @return \code{datatable}
#' @export
DT_style_row <-
  function(table,
           columns = 1,
           rows = NULL,
           valueColumns = columns,
           target = c("row", "cell")[2],
           fontWeight = NULL,
           color = DT_style_row_color(rows = rows, values = backgroundColor, default = default),
           default = NULL,
           backgroundColor,
           lineHeight = NULL,
           ...
  ) {

    if (is.null(rows))
      rows <- 1:length(backgroundColor)
    force(color)
    DT::formatStyle(
      table = table,
      columns = columns,
      valueColumns = valueColumns,
      target = target,
      fontWeight = fontWeight,
      color = DT::styleRow(rows, color),
      backgroundColor = DT::styleRow(rows, backgroundColor),
      lineHeight = lineHeight,
      ...
    )
  }

#' @title Style DT divergent color bar
#'
#' @description Style DT color bars for values that diverge from 0. From \href{https://github.com/federicomarini/GeneTonic}{federicomarini/GeneTonic}
#'
#' @details This function draws background color bars behind table cells in a column,
#' width the width of bars being proportional to the column values *and* the color
#' dependent on the sign of the value.
#'
#' A typical usage is for values such as `log2FoldChange` for tables resulting from
#' differential expression analysis.
#' Still, the functionality of this can be quickly generalized to other cases -
#' see in the examples.
#'
#' The code of this function is heavily inspired from styleColorBar, and borrows
#' at full hands from an excellent post on StackOverflow -
#' https://stackoverflow.com/questions/33521828/stylecolorbar-center-and-shift-left-right-dependent-on-sign/33524422#33524422
#'
#' @param data The numeric vector whose range will be used for scaling the table
#' data from 0-100 before being represented as color bars. A vector of length 2
#' is acceptable here for specifying a range possibly wider or narrower than the
#' range of the table data itself.
#' @param color_pos The color of the bars for the positive values
#' @param color_neg The color of the bars for the negative values
#'
#' @return This function generates JavaScript and CSS code from the values
#' specified in R, to be used in DT tables formatting.
#'
#' @export
#'
#' @examples
#' simplest_df <- data.frame(
#'   a = c(rep("a", 9)),
#'   value = c(-4, -3, -2, -1, 0, 1, 2, 3, 4)
#' )
#'
#' # or with a very simple data frame
#' DT::datatable(simplest_df) %>%
#'   formatStyle(
#'     "value",
#'     background = styleColorBar_divergent(
#'       simplest_df$value,
#'       scales::alpha("forestgreen", 0.4),
#'       scales::alpha("gold", 0.4)
#'     ),
#'     backgroundSize = "100% 90%",
#'     backgroundRepeat = "no-repeat",
#'     backgroundPosition = "center"
#'   )
styleDivergentBar <- function(data,
                              color_pos,
                              color_neg) {
  max_val <- max(abs(data))
  htmlwidgets::JS(
    sprintf(
      "isNaN(parseFloat(value)) || value < 0 ? 'linear-gradient(90deg, transparent, transparent ' + (50 + value/%s * 50) + '%%, %s ' + (50 + value/%s * 50) + '%%,%s  50%%,transparent 50%%)': 'linear-gradient(90deg, transparent, transparent 50%%, %s 50%%, %s ' + (50 + value/%s * 50) + '%%, transparent ' + (50 + value/%s * 50) + '%%)'",
      max_val,
      color_pos,
      max_val,
      color_pos,
      color_neg,
      color_neg,
      max_val,
      max_val
    )
  )
}


#' @title Add \link[DT]{styleColorBar} or `styleDivergentBar` to datatable
#'
#' @inheritParams DT::formatStyle
#' @inheritDotParams DT::formatStyle
#' @inheritDotParams DT::styleColorBar
#' @inheritDotParams styleDivergentBar
#' @param divergent \code{(logical)} Whether to use `styleDivergentBar`
#'
#' @return \code{(datatable)}
#' @export

DT_add_bars <-
  function(table,
           columns,
           valueColumns,
           ...,
           divergent = FALSE) {
    .args <- rlang::dots_list(..., .named = TRUE)
    .args$table <- table
    .data <- table$x$data
    .data_nms <- names(.data)

    if (missing(columns) && divergent)
      .args$columns = stringr::str_which(.data_nms, stringr::regex("frequency", ignore_case = TRUE))
    else
      .args$columns <- columns

    if (missing(valueColumns) && divergent)
      .args$valueColumns = stringr::str_which(.data_nms,
                                              stringr::regex("rank|from_mean", ignore_case = TRUE))
    else
      .args$valueColumns <- valueColumns

    if (divergent)
      bar_args <-
      purrr::list_modify(.args[names(.args) %in% c("color_pos", "color_neg")], color_pos = "#28a745", color_neg = "#dc3545")
    else
      bar_args <- .args[names(.args) %in% c("data", "color", "angle")]

    .args$background <-
      purrr::map(.args$valueColumns,
                 \(.x) rlang::exec(
                   if (divergent) styleDivergentBar else DT::styleColorBar,
                   range(.data[[.x]]),
                   !!!bar_args
                 )) |>
      {
        \(x) {
          purrr::when(length(x), . == 1 ~ x[[1]], ~ x)
        }
      }()

    rlang::exec(DT::formatStyle,!!!.args)
  }
