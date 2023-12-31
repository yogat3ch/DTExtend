% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/header_tooltips.R
\name{DT_header_tooltips}
\alias{DT_header_tooltips}
\title{Add Tippy tooltips to headers}
\usage{
DT_header_tooltips(
  id,
  col_nms,
  tooltips = col_nms,
  calls_only = FALSE,
  .ns = shinyVirga::ns_find(),
  asis = FALSE
)
}
\arguments{
\item{id}{\code{chr} ID of the DT output to tippy the headers}

\item{col_nms}{\code{chr} Column names exactly as displayed on the rendered DT}

\item{tooltips}{\code{chr} content of the tooltips, currently only character strings supported. Make an issue if you would like to see HTML supported}

\item{calls_only}{\code{lgl} whether just to return the tippy calls, to be called with \code{\link[shinyjs]{runjs}}}

\item{.ns}{\code{fun} The ns function}

\item{asis}{\code{lgl} Whether the \code{id} should be used asis, or automatically namespaced.}
}
\value{
\code{chr} JS Code to be passed to \code{DT_callback}
}
\description{
(Requires \code{\href{https://github.com/JohnCoene/tippy}{tippy}} or \code{\href{https://atomiks.github.io/tippyjs/v6/getting-started/}{tippyjs}} dependencies in the DOM)
}
\examples{
# To be used in combination with `DT_callback`. Tooltips can be bound to the rendered event with shinyjs
\dontrun{
observeEvent(input$[DTOutputId]_rendered, {
   shinyjs::runjs(
     DTExtend::DT_header_tooltips(
       id = "policy_choices",
       col_nms = c("[Column names here]"),
       calls_only = TRUE)
     )
   })
}
}
