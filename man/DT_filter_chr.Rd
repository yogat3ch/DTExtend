% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filters.R
\name{DT_filter_chr}
\alias{DT_filter_chr}
\title{Create DT formatted filter statements from a list of filter ranges}
\usage{
DT_filter_chr(filters, nms)
}
\arguments{
\item{filters}{\code{named list} With names corresponding to data column names and numeric ranges (length 2 numeric vector) or character values to be applied to each column}

\item{nms}{\code{chr} Names of each column in the data}
}
\value{
\code{chr} of DT formatted filter statements
}
\description{
Create DT formatted filter statements from a list of filter ranges
}
\examples{
DT_filter_chr(list(`LB Pol Short Freq` = c(65, 67), `Policy ID` = "00"), c("Policy ID", default_choices$performance))
}
