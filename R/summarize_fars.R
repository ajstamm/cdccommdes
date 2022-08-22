#' Summarize FARS accidents
#'
#' This function summarizes deaths and accidents by year and census tract.
#'
#' @param fars     Simple feature containing FARS coordinates linked to
#'                 census tracts.
#' @param tract    Simple feature containing census tracts.
#' @param my_state State FIPS code.
#'

summarize_fars <- function(fars, tract, my_state) {
  s <- data.frame(fars) # convert sf to data frame (table)
  s <- dplyr::group_by(s, !!dplyr::sym("geoid"), !!dplyr::sym("year"))
  s <- dplyr::summarise(s,
              Accidents = length(unique(!!dplyr::sym("st_case"))),
              DeathsAll = sum(!!dplyr::sym("died")),
              DeathsPed = sum(!!dplyr::sym("died_ped")),
              DeathsCyc = sum(!!dplyr::sym("died_cycle")))
  s <- dplyr::rename(s, Year = !!dplyr::sym("year"))
  years <- unique(s$Year)
  y <- dplyr::full_join(tract, data.frame(Year = years), by = character())
  y <- dplyr::left_join(y, s, by = c("geoid", "Year"))
  y <- dplyr::mutate(y, StateFIPSCode = my_state,
                     RowIdentifier = dplyr::row_number())
  y <- data.frame(y)
  y <- dplyr::select(y, !!dplyr::sym("StateFIPSCode"), !!dplyr::sym("RowIdentifier"),
                  !!dplyr::sym("Year"), !!dplyr::sym("geoid"),
                  !!dplyr::sym("Accidents"), !!dplyr::sym("DeathsAll"),
                  !!dplyr::sym("DeathsPed"), !!dplyr::sym("DeathsCyc"))
  y[is.na(y)] <- 0
  return(y)
}
