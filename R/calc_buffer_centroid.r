#' Calculate buffer centroid
#'
#' Calculate the centroid for a set of very close intersections
#' (within a defined buffer).
#'
#' @param area     Point layer.
#' @param width    Buffer radius.
#'
#'
# not intended for export
# need to keep as dedicated sf


calc_buffer_centroid <- function(area, width = 0) {
  # each buffer separate; faster than dissolve = TRUE
  # buffer <- raster::buffer(points, width = 30, dissolve = FALSE)
  # overlapping buffers merged; however, very slow
  # d <- raster::buffer(area, width = width, dissolve = dissolve)
  d <- sf::st_as_sf(area) # not necessary?
  d <- sf::st_buffer(d, width)
  # break buffers into separate objects
  d <- sf::st_cast(d, "POLYGON")


  # steal the next part from revised GAT
  # add centroids - not straightforward in sf ####
  # assume all other values constant (they aren't affected anyway)
  sf::st_agr(d) <- "constant"
  d <- sf::st_centroid(d)
  sf::st_geometry(d) <- sf::st_centroid(d$geometry)
  # popshp <- sf::st_transform(popshp, sf::st_crs(area))
  pts <- do.call(rbind, sf::st_geometry(d))
  pts <- data.frame(pts)
  names(pts) <- c("x", "y")

  # # centroids <- sf::st_centroid(d)
  # d <- sf::as_Spatial(d)
  #
  # # give each feature an ID to assign centroids
  # d@data <- cbind(d@data, id = 1:nrow(d@data))
  #
  # # use number from bdissolve, take centroid, join to tract?
  # centroids <- rgeos::gCentroid(d, byid = TRUE)
  # cen <- sp::SpatialPointsDataFrame(centroids, data.frame(id = 1:281397))

  # final centroids
  return(pts)
}
