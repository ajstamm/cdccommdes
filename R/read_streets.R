#' Read streets shapefile
#'
#' This function reads in the streets shapefile, isolates only the street types
#' of interest, combines smaller segments of the same street, and returns a
#' clean street layer.
#'
#' @param path File path.
#' @param shp  Streets shapefile.
#'

read_streets <- function(path, shp) {
  # massive file; takes ~15 minutes to read in
  d <- sf::st_read(path, shp) # n = 1080969
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
  return(f)
}
