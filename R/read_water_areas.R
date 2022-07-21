#' Prepare intersection density water areas
#'
#' This function reads in the desired shapefile, subsets only developable
#' land, and buffers the polygons.
#'
#' @param shp_path  String denoting absolute or relative path.
#' @param gdb       String denoting the geodatabase name.
#' @param shp_name  String denoting the geodatabase layer name.
#' @param save_path String denoting the path to save the processed
#'                  shapefile, if any.
#'
#' Download your state's shapefile from
#' https://apps.nationalmap.gov/downloader/#/
#'
#' The buffering step removes self-crossing boundaries, which throw errors
#' in later processing steps if not addressed.
#'
#'
prep_water_areas_obsolete <- function(shp_path, gdb, shp_name, save_path = NULL) {
  # water bodies ----
  # read in water features
  # download your state from
  # https://apps.nationalmap.gov/downloader/#/
  # load NHDArea, NHDWaterbody
  # rgdal::ogrListLayers("data/NHD/NHD_H_New_York_State_GDB.gdb")
  # a <- rgdal::readOGR(dsn = gdb, layer = "NHDArea") # not used?
  # read in sf to start?
  gdb_path <- paste(shp_path, gdb, sep = "/")
  w <- sf::st_read(dsn = gdb_path, layer = shp_name)
  # validate polygons n=161810
  w <- sf::st_make_valid(w) # fix invalid areas
  w <- sf::st_combine(w) # combine all geometries into one feature
  sf::sf_use_s2(FALSE) # because combining can invalidate areas,
                       # and make_valid won't work right -
                       # FALSE turns off spherical geometry check
  w <- sf::st_union(w) # union all geometries (must combine first?)
  if (!is.null(save_path)) {
    sf::st_write(w, dsn = save_path, layer = "water_areas",
                 driver = "ESRI Shapefile")
  }
  return(w)
}

prep_water_areas <- function(shppath, shp, gdb) {
  # protected areas ----
  # download your state from
  # https://www.usgs.gov/core-science-systems/science-analytics-and-synthesis/gap/science/pad-us-data-download?qt-science_center_objects=0#qt-science_center_objects
  p <- sf::st_read(dsn = shppath, layer = shp)
  # p <- rgdal::readOGR(dsn = shppath, layer = shp)
  # remove “Wild and Scenic River” (WSR), “Special Designation Area” (SDA), and
  #        “National Scenic, Botanical or Volcanic” (NSBV)
  p <- p[!p$Des_Tp %in% c("NSBV", "WSR", "SDA"), ]
  # validate polygons n=11214
  # p <- rgeos::gBuffer(p, width = 0, byid = FALSE)
  p <- sf::st_combine(p)
  p <- sf::st_union(p)
  p <- sf::as_Spatial(p)
  # pa_d <- raster::aggregate(pa, dissolve = TRUE)
  # above failed (timed out?), so try:
  # pa_d <- rgeos::gUnaryUnion(pa)

  # water bodies ----
  # read in water features
  # download your state from
  # https://apps.nationalmap.gov/downloader/#/
  # load NHDArea, NHDWaterbody
  # rgdal::ogrListLayers("data/NHD/NHD_H_New_York_State_GDB.gdb")
  # a <- rgdal::readOGR(dsn = gdb, layer = "NHDArea") # not used?
  # w <- rgdal::readOGR(dsn = gdb, layer = "NHDWaterbody")
  # validate polygons n=161810
  # w <- rgeos::gBuffer(w, width = 0, byid = FALSE)
  # nhdw_d <- rgeos::gUnaryUnion(nhdw)
  # w <- sf::st_as_sf(w)
  w <- sf::st_read(dsn = gdb, layer = "NHDWaterbody")
  w <- sf::st_combine(w)
  w <- sf::st_union(w)
  w <- sf::st_zm(w)
  w <- sf::as_Spatial(w)

  # merge water (nhdw) and protected areas (pa)
  d <- raster::bind(p, w)
  # pa_w2 <- raster::bind(pa_d, nhdw_d)

  return(d)
}

