#' Generic indicator save function
#'
#' @param filename String to name the file.
#' @param dataset  Dataset (data.frame or simple feature) to save.
#' @param savepath String for the relative or absolute path to save the files.
#' @param rds      Boolean denoting whether to save the dataset as an R data
#'                 object.
#' @param xml      Boolean denoting whether to save the dataset as an XML file.
#' @param csv      Boolean denoting whether to save the dataset as a CSV file.
#' @param shp      Boolean denoting whether to save the dataset as a shapefile.
#'
#'
#' @description
#' This function saves up to four user-selected files to the same folder,
#' including:
#'
#' * an XML file
#' * an R object
#' * a shapefile (if the dataset read in is a simple feature)
#' * a CSV file (to run through CDC's XML Generator)
#'
#' At some point, this function will be revised to add a header to the
#' beginning of the XML file, probably by reading in a standard text file
#' containing the header code or producing a basic pop-up like the XML
#' Generator to collect information.
# (plan to shamelessly steal from GAT's GUI)
#'
#' @export
#'
# I was having issues writing to XML, so this feature/option still needs work
# writing to shapefile requires a filepath, so if it's blank, I created one

save_generic <- function(dataset, filename, savepath = "", rds = TRUE,
                         xml = FALSE, shp = FALSE, csv = TRUE) {
  file_name <- paste(filename, Sys.Date(), sep = "_") # filename without extension
  if (savepath == "") savepath <- "saves"
  savepath <- gsub("/$", "", savepath)
  file_path <- paste(savepath, file_name, sep = "/") # file path & name

  if (rds) saveRDS(dataset, paste0(file_path, ".Rds"))
  if (xml) {
    # I found a hacky workaround at https://github.com/r-lib/xml2/issues/213,
    # but it performs very poorly for large datasets
    # still searching for a better solution
  }
  if (csv) {
    d <- data.frame(dataset)
    utils::write.csv(d, paste0(file_path, ".csv"))
  }
  if (shp) {
    # check if simple feature
    if ("sf" %in% class(dataset)) {
      sf::st_write(dataset, dsn = savepath, layer = file_name,
                   driver = "ESRI Shapefile")
    }
  }
}
