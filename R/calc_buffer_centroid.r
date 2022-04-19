#' Calculate buffer centroid
#'
#' Calculate the centroid for a set of very close intersections
#' (within a defined buffer).
#'
#' @param area     Point layer.
#' @param width    Buffer radius.
#' @param dissolve Whether to merge overlapping buffers,
#'                 but this option is slow.
#'
#'
# not intended for export
# need to keep as dedicated sf


calc_buffer_centroid <- function(area, width = 30, dissolve = TRUE) {
  # each buffer separate; faster than dissolve = TRUE
  # buffer <- raster::buffer(points, width = 30, dissolve = FALSE)
  # overlapping buffers merged; however, very slow
  d <- raster::buffer(area, width = width, dissolve = dissolve)
  # break buffers into separate objects
  d <- sf::st_as_sf(d)
  d <- sf::st_cast(d, "POLYGON")
  # centroids <- sf::st_centroid(d)
  d <- sf::as_Spatial(d)

  # give each feature an ID to assign centroids
  d@data <- cbind(d@data, id = 1:nrow(d@data))

  # use number from bdissolve, take centroid, join to tract?
  centroids <- rgeos::gCentroid(d, byid = TRUE)
  cen <- sp::SpatialPointsDataFrame(centroids, data.frame(id = 1:281397))

  # final centroids
  return(cen)
}
