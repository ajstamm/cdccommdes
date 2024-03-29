% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/save_generic.R
\name{save_generic}
\alias{save_generic}
\title{Generic indicator save function}
\usage{
save_generic(
  dataset,
  filename,
  savepath = "",
  rds = TRUE,
  xml = FALSE,
  shp = FALSE,
  csv = TRUE
)
}
\arguments{
\item{dataset}{Dataset (data.frame or simple feature) to save.}

\item{filename}{String to name the file.}

\item{savepath}{String for the relative or absolute path to save the files.}

\item{rds}{Boolean denoting whether to save the dataset as an R data
object.}

\item{xml}{Boolean denoting whether to save the dataset as an XML file.}

\item{shp}{Boolean denoting whether to save the dataset as a shapefile.}

\item{csv}{Boolean denoting whether to save the dataset as a CSV file.}
}
\description{
This function saves up to four user-selected files to the same folder,
including:
\itemize{
\item an XML file
\item an R object
\item a shapefile (if the dataset read in is a simple feature)
\item a CSV file (to run through CDC's XML Generator)
}

At some point, this function will be revised to add a header to the
beginning of the XML file, probably by reading in a standard text file
containing the header code or producing a basic pop-up like the XML
Generator to collect information.
}
