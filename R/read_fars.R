#' Read in FARS data
#'
#' This function reads in and combines the Accident, Person, and PB type
#' datasets, which are the ones used for the traffic fatality indicators.
#'
#' @param filepath String denoting your absolute or relative file path.
#' @param years    Vector of years for which you have data.
#' @param my_state State FIPS code.
#'
#' To use this function, download the FARS zip files from
#' the [FARS website](https://www.nhtsa.gov/node/97996/251)
#' and uzip all files to their default folders within the same folder.
#' Use the path to this folder as your filepath in the function. Remember,
#' R uses forward slash (/) for file paths. Make sure all years in your years
#' vector are in the folder (they need not be sequential) or R will throw a
#' missing file error.
#'
#'

read_fars <- function(filepath, years, my_state) {
  # read the yearly datasets into lists
  #---- read accidents ----
  d <- list()
  for (i in years) {
    fars_path <- paste0(filepath, "/FARS", i, "NationalCSV/ACCIDENT.CSV")
    d[[i]] <- utils::read.csv(fars_path)
  }
  a <- dplyr::bind_rows(d) # turn the list into a data frame (table)
  a <- dplyr::filter(a, !!dplyr::sym("STATE") == my_state) # in-state accidents
  a <- dplyr::select(a, !!dplyr::sym("YEAR"), !!dplyr::sym("ST_CASE"),
                     !!dplyr::sym("FATALS"), !!dplyr::sym("LATITUDE"),
                     !!dplyr::sym("LONGITUD"))

  #---- read persons ----
  d <- list()
  for (i in years) {
    fars_path <- paste0(filepath, "/FARS", i, "NationalCSV/PERSON.CSV")
    d[[i]] <- utils::read.csv(fars_path)
    d[[i]]$YEAR <- i
  }
  p <- dplyr::bind_rows(d)
  p <- dplyr::select(p, !!dplyr::sym("YEAR"), !!dplyr::sym("ST_CASE"),
                     !!dplyr::sym("PER_NO"), !!dplyr::sym("DOA"),
                     !!dplyr::sym("VEH_NO"), !!dplyr::sym("INJ_SEV"))
  p <- dplyr::right_join(p, a, by = c("YEAR", "ST_CASE"))
  #---- read pedestrians ----
  d <- list()
  for (i in years) {
    fars_path <- paste0(filepath, "/FARS", i, "NationalCSV/PBTYPE.CSV")
    d[[i]] <- utils::read.csv(fars_path)
    d[[i]]$YEAR <- i
  }
  f <- dplyr::bind_rows(d)
  f <- dplyr::select(f, !!dplyr::sym("YEAR"), !!dplyr::sym("ST_CASE"),
                     !!dplyr::sym("VEH_NO"), !!dplyr::sym("PER_NO"),
                     !!dplyr::sym("PBPTYPE"))
  f <- dplyr::right_join(f, p, by = c("YEAR", "ST_CASE", "VEH_NO", "PER_NO"))

  #---- prep final dataset ----
  # subset only valid coordinates
  # this is our final fatalities dataset
  all <- dplyr::mutate(f,
           died = !!dplyr::sym("INJ_SEV") == 4, # deaths up to 28 days later
           died_ped = !!dplyr::sym("died") & !!dplyr::sym("PBPTYPE") == 5,
           died_cycle = !!dplyr::sym("died") & !!dplyr::sym("PBPTYPE") %in% 6:7)
  all <- dplyr::filter(all, !!dplyr::sym("died"),      # only deaths
                       !!dplyr::sym("LONGITUD") < 0) # only valid coordinates
  all <- dplyr::rename_all(all, tolower)
  #---- return ----
  return(all)
}
