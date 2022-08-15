#' Read in and prep ArcGIS Online street layer
#'
#' This function pulls the HPMS layer of interest from the ArcGIS Online server,
#' isolates the variables of interest (AADT and street name), and converts it
#' from multilinestring to linestring to make processing easier.
#'
#' @param my_state String denoting state abbreviation or FIPS code.
#' @param year    String or number denoting data year.
#' @param path    Path to save the resulting layer, if desired. Two layers are
#'                saved: "clean_arc_streets.shp" contains all streets and
#'                "aadt_arc_streets.shp" (the output object) contains only
#'                streets with non-missing AADT values.
#'
#'
# read arc online aadt file and prep
# nys takes about 27 minutes

prep_arc_aadt <- function(my_state = "RI", year = 2019, path = NULL) {
  # https://geo.dot.gov/server/rest/services/Hosted
  arc <- paste("https://geo.dot.gov/server/rest/services/Hosted/HPMS_",
               my_state, "_GeoIntersections_", year, "/FeatureServer/0",
               sep = "")
  h <- arcpullr::get_spatial_layer(url = arc)
  # turn each line into a separate feature
  # running the linestring check twice removes geometry collections
  # that I believe are empty anyway
  for (i in 1:2) {
    h$geo_type <- sf::st_geometry_type(h)
    # handle multilinestrings separately and rejoin
    # can only merge MULTI*, so separate it out
    hm <- dplyr::filter(h, !!dplyr::sym("geo_type") == "MULTILINESTRING")
    hm <- sf::st_line_merge(hm)
    hs <- dplyr::filter(h, !!dplyr::sym("geo_type") == "LINESTRING")
    h <- dplyr::bind_rows(hm, hs)
  }
  rm(hs, hm, arc)
  # h$full_lngth <- sf::st_length(h) # 184852 missing aadt - not needed
  a <- dplyr::filter(h, !is.na(!!dplyr::sym("aadt"))) # 326394/511246 roads in NYS
  a <- dplyr::select(a, !!dplyr::sym("aadt"), !!dplyr::sym("route_name"))

  if (!is.null(path)) {
    # because the dbf driver truncates all names weirdly if one is too long ...
    names(a) <- substr(names(a), 1, 10)
    names(h) <- substr(names(h), 1, 10)
    sf::st_write(h, dsn = path, layer = "clean_arc_streets",
                 driver = "ESRI Shapefile")
    sf::st_write(a, dsn = path, layer = "aadt_arc_streets",
                 driver = "ESRI Shapefile")
  }
  return(a)
}


# read roads ----
# 30 minutes from pulling to saving layer for NYS
# a <- prep_arc_aadt(my_state = "NY", year = 2019, path = "data/HPMS/test")





