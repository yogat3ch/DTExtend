luminance = function(col) c(c(.299, .587, .114) %*% col2rgb(col)/255)

#' Select the black/white font color based on background color value
#'
#' @param values \code{chr} hex color values
#' @param luminance_threshold \code{dbl} luminance threshold where > this value (brighter background values) will have black font and < this value will have white font
#'
#' @return \code{chr} vector of colors in rgb form
#' @export

font_color <- function(values, luminance_threshold = .5) {
  lum <- luminance(values)
  purrr::map_chr(lum, ~{
    if (.x > luminance_threshold)
      d = 0 # bright colors - black font
    else
      d = 255 # dark colors - white font
    glue::glue("rgb({d}, {d}, {d})")
  })
}
#' Create a call to \link[DT]{styleRow} for matching color to backgroundColor for contrast
#'
#' @inherit DT::styleRow params return
#' @param luminance_threshold \code{num} value between 0 1 as the luminance threshold of the background that shifts the color to a contrasting color
#' @export
#'

DT_style_row_color <- function(rows, values, default = NULL, luminance_threshold = .5) {
  DT::styleRow(
    rows = rows,
    values = UU::color_text_by_luminance(values, text_dark = "#333", text_light = "#FFF"),
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
