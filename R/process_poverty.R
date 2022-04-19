#' Process data for the poverty indicator
#'
#' @param readpath   String for the relative or absolute file path.
#' @param gdb_name   String containing the geodatabase name, without the ".gdb"
#'                   suffix, which is added as needed in the function.
#' @param layer_name String containing the name of the poverty table in the
#'                   geodatabase. If you don't know the table name, run
#'                   `rgdal::ogrListLayers(gdb_path_and_name)` to list all
#'                   files, where "gdb_path_and_name" is the full path to the
#'                   geodatabase.
#'
#' This function reads in the poverty data from the geodatabase and processes
#' it as directed in the indicator development documentation. This function
#' exports a simple feature object.
#'
# @examples
#'
#'
#' @export


process_poverty <- function(readpath, gdb_name, layer_name) {
  # sf will correctly read non-layer tables; check names with
  # rgdal::ogrListLayers(paste(files_path, gdb_name, sep = "/"))
  dsn <- paste(readpath, paste0(gdb_name, ".gdb"), sep = "/")
  # download desired ACS data (2018 NYS) from
  # https://www2.census.gov/geo/tiger/TIGER_DP/
  # unzip the geodatabase to a folder called "ACS" in the project's data folder
  # below, leave off ".gdb" because the folder name and layer name are the same
  # and we can add the extension manually when we call the folder
  pov <- sf::st_read(dsn = dsn, layer = layer_name)
  pov <- dplyr::mutate(pov, GEOID = substr(!!dplyr::sym("GEOID"), 8, 18),
           Year = substr(gsub("[^0-9]", "", gdb_name), 1, 4))

  tract <- sf::st_read(dsn = dsn, layer = gdb_name)
  sf <- dplyr::full_join(tract, pov, by = "GEOID")
  # B17017e1 = all households (denominator)
  # B17017e2 = households below poverty (numerator)
  # Pct_HH_Below_Poverty = B17017e2 / B17017e1 (shortened to 10 char for DBF)
  # B17017m1 and B17017m2: note these for validation later (what are they?)
  # add people in poverty and all people
  # from the lookup table: B17021,0055,1 = total individuals (B17021e1)
  #                        B17021,0055,2 = below poverty     (B17021e2)
  sf <- dplyr::rename(sf, HHPov = !!dplyr::sym("B17017e2"),
                      HHTotal = !!dplyr::sym("B17017e1"),
                      PopPov = !!dplyr::sym("B17021e2"),
                      PopTotal = !!dplyr::sym("B17021e1"))
  sf <- dplyr::select(sf, !!dplyr::sym("Year"), !!dplyr::sym("GEOID"),
                      !!dplyr::sym("HHPov"), !!dplyr::sym("HHTotal"),
                      !!dplyr::sym("PopPov"), !!dplyr::sym("PopTotal"))
  sf <- dplyr::mutate(sf,
          PctHHPov = 100 * !!dplyr::sym("HHPov") / !!dplyr::sym("HHTotal"),
          PctHHPov = ifelse(!is.finite(!!dplyr::sym("PctHHPov")), 0,
                             !!dplyr::sym("PctHHPov")),
          PctPopPov = 100 * !!dplyr::sym("PopPov") / !!dplyr::sym("PopTotal"),
          PctPopPov = ifelse(!is.finite(!!dplyr::sym("PctPopPov")), 0,
                            !!dplyr::sym("PctPopPov")),
          RowIdentifier = dplyr::row_number())
  # still a simple feature
  sf <- dplyr::select(sf, !!dplyr::sym("RowIdentifier"), !!dplyr::sym("Year"),
                      !!dplyr::sym("GEOID"), !!dplyr::sym("HHTotal"),
                      !!dplyr::sym("HHPov"), !!dplyr::sym("PctHHPov"),
                      !!dplyr::sym("PopTotal"), !!dplyr::sym("PopPov"),
                      !!dplyr::sym("PctPopPov"))
  return(sf)
}
