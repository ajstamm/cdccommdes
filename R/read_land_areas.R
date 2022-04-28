#' Prepare developable land layer
#'
#' This function reads in the desired shapefile, subsets only developable
#' land, and buffers the polygons.
#'
#' @param shp_path  String denoting absolute or relative path.
#' @param shp_name  String denoting shapefile name.
#' @param save_path String denoting the path to save the processed
#'                  shapefile, if any.
#'
#' Download your state's shapefile from
#' [USGS](https://www.usgs.gov/core-science-systems/science-analytics-and-synthesis/gap/science/pad-us-data-download?qt-science_center_objects=0#qt-science_center_objects)
#'
#' The subsetting step removes the following areas:
#'
#' * "Wild and Scenic River” (WSR)
#' * “Special Designation Area” (SDA)
#' * “National Scenic, Botanical or Volcanic” (NSBV)
#'
#' The buffering step removes self-crossing boundaries, which throw errors
#' in later processing steps if not addressed.
#'
#'
#'

read_land_areas <- function(shp_path, shp_name, save_path = NULL) {
  # # protected areas ----
  # # download your state from
  # # https://www.usgs.gov/core-science-systems/science-analytics-and-synthesis/gap/science/pad-us-data-download?qt-science_center_objects=0#qt-science_center_objects
  # p <- sf::st_read(dsn = shppath, layer = shp)
  # # p <- rgdal::readOGR(dsn = shppath, layer = shp)
  # # remove “Wild and Scenic River” (WSR), “Special Designation Area” (SDA), and
  # #        “National Scenic, Botanical or Volcanic” (NSBV)
  # p <- p[!p$Des_Tp %in% c("NSBV", "WSR", "SDA"), ]
  # # validate polygons n=11214
  # # p <- rgeos::gBuffer(p, width = 0, byid = FALSE)
  # p <- sf::st_combine(p)
  # p <- sf::st_union(p)
  # p <- sf::as_Spatial(p)
  # # pa_d <- raster::aggregate(pa, dissolve = TRUE)
  # # above failed (timed out?), so try:
  # # pa_d <- rgeos::gUnaryUnion(pa)
  p <- sf::st_read(dsn = shp_path, layer = shp_name)
  p <- dplyr::select(p, !!dplyr::sym("geometry"), !!dplyr::sym("Des_Tp"))
  p <- dplyr::filter(p, !(!!dplyr::sym("Des_Tp") %in% c("NSBV", "WSR", "SDA")))
  p <- sf::st_buffer(p, 0)
  # removing linestrings - not relevant?
  # p$cnt2 = stringr::str_count(p$geometry, ",")
  # p <- dplyr::filter(p, cnt2 > 1)

  p <- sf::st_union(p)
  # plot(p$geometry)
  # p <- sf::st_combine(p) # combine all geometries into one feature
  if (!is.null(save_path)) {
    sf::st_write(p, dsn = save_path, layer = "land_areas",
                 driver = "ESRI Shapefile")
  }
  return(p)
}
