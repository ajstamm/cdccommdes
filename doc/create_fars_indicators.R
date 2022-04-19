## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----package, eval=FALSE------------------------------------------------------
#  library(cdccommdes)
#  # to learn more about the package, type
#  citation("cdccommdes")        # suggested citation
#  browseVignettes("cdccommdes") # tutorials and documentation
#  ?cdccommdes                   # help files and about page

## ----settings, eval=FALSE-----------------------------------------------------
#  # my file path
#  # note the forward slashes (Windows users will need to change them manually)
#  my_path <- "c:/my_projects/fars"
#  # my state's census tract shapefile, without the extensions
#  my_tracts <- "tl_2010_36_tract10"
#  my_fips <- 36         # state FIPS number
#  my_years <- 2015:2018 # any vector of years (single years also work)
#                        # skipped years are untested
#  geoid <- "GEOID10"    # shapefile ID number

## ----processing, eval=FALSE---------------------------------------------------
#  # enter your settings from above
#  f <- process_fars(readpath = my_path, shp_name = my_tracts,
#                    years = my_years, tract_id = geoid, my_state = my_fips)

## ----saving, eval=FALSE-------------------------------------------------------
#  # at this time, the XML file does not incorporate CDC metadata
#  save_generic(filename = "tract_safety_indicators", dataset = f,
#               savepath = my_path)

