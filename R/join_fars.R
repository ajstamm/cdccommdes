#' Join FARS accident locations to tract
#'
#' This function joins the coordinates of FARS accidents to the tracts in
#' which they occur. This function is short, but takes several minutes to run
#' depending on the number of points in your dataset.
#'
#' @param fars  Dataset containing FARS data (data.frame or similar).
#' @param tract Simple feature containing tract information.
#'
#'
#'
# not exported

# Joining deaths and tracts may take several minutes.
join_fars <- function(fars, tract) {
  # plot fatality coordinates
  xy <- sf::st_as_sf(fars, coords = c("longitud", "latitude"),
                     crs = sf::st_crs(tract))
  # intersect the two sf objects
  # this assigns tracts to point-level data
  # note the warning, but in my experience, it can generally be ignored
  # this step may be slow if you have a lot of people involved
  sf <- sf::st_intersection(xy, tract)
  return(sf)
}
