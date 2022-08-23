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
#  my_path <- "c:/my_projects/acs"
#  # my state's census tract geodatabase, without the extensions
#  my_gdb <- "ACS_2018_5YR_TRACT_36_NEW_YORK"
#  my_layer <- "X17_POVERTY"    # table in the geodatabase

## ----processing, eval=FALSE---------------------------------------------------
#  # enter your settings from above
#  f <- process_poverty(readpath = my_path, gdb_name = my_gdb,
#                       layer_name = my_layer)

## ----saving, eval=FALSE-------------------------------------------------------
#  # at this time, the XML file does not incorporate CDC metadata
#  save_generic(filename = "tract_safety_indicators", dataset = f,
#               savepath = my_path,
#               rds = TRUE, xml = TRUE,
#               shp = TRUE, csv = TRUE)

