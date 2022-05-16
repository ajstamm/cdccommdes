#' Create the FARS indicators
#'
#' This function combines all FARS functions to create the full dataset of
#' FARS indicators. It outputs a final dataset for you to save in whatever
#' format you desire.
#'
#' @param readpath   String denoting your absolute or relative file path.
#' @param shp_name   String denoting the name of the shapefile.
#' @param years      Vector of years for which you have data.
#' @param tract_id   String denoting the variable name for the 11-digit tract
#'                   number.
#' @param my_state   State FIPS code.
#' @param data_check Boolean that indicates whether or not R should produce a
#'                   simple map at the end that overlays accident locations on
#'                   census tracts.
#'
#' If you include the data check, plotting may be a bit slow.
#'
#' @export


process_fars <- function(readpath,shp_name,  years, tract_id,
                         my_state, data_check = FALSE) {
  all_deaths <- read_fars(filepath = readpath, years = years,
                          my_state = my_state)
  tract <- read_fars_tract(filepath = readpath, shp_name = shp_name,
                           id = tract_id)
  xy <- join_fars(fars = all_deaths, tract = tract)
  # to this point, object is SF
  sum <- summarize_fars(fars = xy, tract = tract, my_state = my_state)
  # rejoin final to tract to create final SF?
  final <- dplyr::full_join(tract, sum, by = "GEOID")

  if (data_check) {
    # do more points correspond with higher counts?
    # graphics::par(mar=c(2.5,0,2,0), mgp = c(0, 0, 0), xpd = TRUE)
    cols <- c("#fff7bc", "#fec44f", "#d95f0e")
    cls <- classInt::classIntervals(final$DeathsAll, style = "fixed",
                                    n = length(unique(final$DeathsAll)))
    colcode <- classInt::findColours(cls, cols)

    l <- leaflet::leaflet(final)
    l <- leaflet::addProviderTiles(l, leaflet::providers$OpenTopoMap)
    l <- leaflet::addPolygons(l, data = final, label = ~GEOID, color = "grey",
                              fillColor = colcode, weight = 1,
                              opacity = 0.8, fillOpacity = 0.7)
    l <- leaflet::addMarkers(l, data = xy, label = ~ST_CASE,
                             clusterOptions = leaflet::markerClusterOptions())
    print(l)
  }
  return(final)
}
