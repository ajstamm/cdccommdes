#' Read streets shapefile
#'
#' This function reads in the streets shapefile, isolates only the street types
#' of interest, combines smaller segments of the same street, and returns a
#' clean street layer.
#'
#' @param shp_path  String denoting absolute or relative path, which may
#'                  include the geodatabase name, if relevant.
#' @param shp_name  String denoting the shapefile or geodatabase layer name.
#' @param save_path String denoting the path to save the processed
#'                  shapefile, if any.
#'

read_streets <- function(shp_path, shp_name, save_path = NULL) {
  # massive file; takes ~15 minutes to read in
  d <- sf::st_read(shp_path, shp_name) # n = 1080969
  # select code %in% 5112:5123 only
  e <- dplyr::filter(d, !!dplyr::sym("code") %in% 5112:5123) # n = 374677
  # turn each line into a separate feature
  e <- dplyr::group_by(e, !!dplyr::sym("name"))
  f <- dplyr::summarize(e) # n = 100051
  f$geo_type <- sf::st_geometry_type(f)
  f1 <- dplyr::filter(f, !!dplyr::sym("geo_type") == "LINESTRING")
  # can only merge MULTI*, so separate it out
  f2 <- dplyr::filter(f, !!dplyr::sym("geo_type") == "MULTILINESTRING")
  f2 <- sf::st_line_merge(f2)
  # table(sf::st_geometry_type(f2))
  f <- dplyr::bind_rows(f1, f2)
  rm(f1, f2, d, e)
  if (!is.null(save_path)) {
    sf::st_write(f, dsn = save_path, layer = "clean_streets",
                 driver = "ESRI Shapefile")
  }
  return(f)
}
