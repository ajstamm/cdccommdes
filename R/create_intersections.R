#' Create road intersections
#'
#' Create the road intersections.
#'
#' @param path File path.
#' @param shp  Shapefile name.
#'
#'
# not intended to be exported

create_intersections <- function(path, shp) {
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
  rm(f1, f2)

  # calculate where separate lines cross; self-intersections excluded?
  # below this point takes forever; not fully tested
  s <- sf::st_intersection(f)
  # create explicit geometry variable and retain only point geometries
  # multipoint also retained here; are multipoints y intersections?
  s$geo_type <- sf::st_geometry_type(s)
  s <- dplyr::filter(s, grepl("POINT", !!dplyr::sym("geo_type")))
  s <- sf::st_cast(s, "POINT") # force multipoint to single point
  rm(f)
  return(s)
}
