#' Read census tract file
#'
#' This function reads in the census tract file and standardizes the name of
#' the 11-digit tract number for the indicator calculations.
#'
#' @param filepath String denoting your absolute or relative file path.
#' @param shp_name String denoting the name of the shapefile.
#' @param id       String denoting the variable name for the 11-digit tract
#'                 number.
#'
#' Download your census tract file from the
#' [US Census](https://www.census.gov/cgi-bin/geo/shapefiles/index.php)
#' and place it in the folder denoted in your filepath. Check which variable
#' contains the 11-digit tract number to place in the id option.


# Place the tract-level shapefile you downloaded from the census website in
# the same folder as the unzipped FARS data folders. Note the name of the
# tract ID variable in the shapefile, probably GEOID or GEOID10.
read_fars_tract <- function(filepath, shp_name, id) {
  tract <- sf::st_read(dsn = filepath, layer = shp_name)
  tract <- dplyr::select(tract, !!dplyr::sym(id))
  tract <- dplyr::rename(tract, GEOID = !!dplyr::sym(id))
  return(tract)
}
