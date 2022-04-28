#' Create road intersections
#'
#' Create the road intersections. This function takes a long time to run due
#' to the massive size of road shapefiles.
#'
#' @param shp       Cleaned streets layer.
#' @param save_path String denoting the path to save the processed
#'                  shapefile, if any.
#'
#'
# not intended to be exported

create_intersections <- function(shp, save_path = NULL) {
  # massive file; takes ~15 minutes to read in
  # calculate where separate lines cross; self-intersections excluded?
  # below this point takes forever; not fully tested
  s <- sf::st_intersection(shp)
  # create explicit geometry variable and retain only point geometries
  # multipoint also retained here; are multipoints y intersections?
  s$geo_type <- sf::st_geometry_type(s)
  s <- dplyr::filter(s, grepl("POINT", !!dplyr::sym("geo_type")))
  s <- sf::st_cast(s, "POINT") # force multipoint to single point
  if (!is.null(save_path)) {
    sf::st_write(s, dsn = save_path, layer = "clean_intersections",
                 driver = "ESRI Shapefile")
  }
  return(s)
}
