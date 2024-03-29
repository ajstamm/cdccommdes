% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/process_poverty.R
\name{process_poverty}
\alias{process_poverty}
\title{Process data for the poverty indicator}
\usage{
process_poverty(readpath, gdb_name, layer_name)
}
\arguments{
\item{readpath}{String for the relative or absolute file path.}

\item{gdb_name}{String containing the geodatabase name, without the ".gdb"
suffix, which is added as needed in the function.}

\item{layer_name}{String containing the name of the poverty table in the
geodatabase. If you don't know the table name, run
\code{rgdal::ogrListLayers(gdb_path_and_name)} to list all
files, where "gdb_path_and_name" is the full path to the
geodatabase.

This function reads in the poverty data from the geodatabase and processes
it as directed in the indicator development documentation. This function
exports a simple feature object.}
}
\description{
Process data for the poverty indicator
}
