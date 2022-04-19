#' Count road intersections
#'
#' Count the number of intersections in an area.
#'
#' @param centroids Road intersection point layer.
#' @param tractshp  Census tract layer.
#'
# not intended to be exported
# need to convert from sp to sf


count_intersections <- function(centroids, tractshp) {
  c <- sp::spTransform(centroids, sp::proj4string(tractshp))
  # assign points to tracts
  cts <- sp::over(c, tractshp)

  # summarize points by tract to join to tract layer
  sums <- dplyr::group_by(!!dplyr::sym("cts"), !!dplyr::sym("GEOID10"))
  sums <- dplyr::summarize(sums, cts = dplyr::n())

  # join summarized points to tract
  # is there a more direct way than summarizing and rejoining?
  tractshp@data <- dplyr::left_join(tractshp@data, sums, by = "GEOID10")

  return(tractshp)
}
