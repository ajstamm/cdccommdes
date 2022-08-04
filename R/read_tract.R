#' Read census tract file
#'
#' This function reads in the census tract file from the tigris package and
#' standardizes the name of the 11-digit tract number for the indicator
#' calculations.
#'
#' @param my_state String denoting state abbreviation or FIPS code.
#' @param year     String or number denoting data year.
#'
# @example
# x <- read_tract(my_state = "RI")
#'
#'
#'

read_tract <- function(my_state, year = 2010) {
  g <- tigris::tracts(state = my_state, year = year)
  if ("GEOID10" %in% names(g)) {
    g <- dplyr::mutate(g, geoid = !!dplyr::sym("GEOID10"))
  } else {
    g <- dplyr::mutate(g, geoid = !!dplyr::sym("GEOID"))
  }
  g <- dplyr::select(g, !!dplyr::sym("geoid"))
  g <- dplyr::mutate(g, id = dplyr::row_number())
  return(g)
}
