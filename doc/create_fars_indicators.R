## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----package, eval=FALSE------------------------------------------------------
#  library(cdccommdes)
#  
#  # to learn more about the package, type
#  citation("cdccommdes")        # suggested citation
#  browseVignettes("cdccommdes") # tutorials and documentation
#  ?cdccommdes                   # help files and about page

## ----settings, eval=FALSE-----------------------------------------------------
#  # my file path
#  # note the forward slashes (Windows users will need to change them manually)
#  my_path <- "c:/my_projects/fars"
#  # state census tract is now read from the tigris package
#  my_fips <- 36         # state FIPS number
#  my_years <- 2015:2018 # any vector of years (single years also work)
#                        # skipped years are untested

## ----processing, eval=FALSE---------------------------------------------------
#  # your custom settings in the previous step will be passed through the function
#  f <- process_fars(readpath = my_path, years = my_years,
#                    my_state = my_fips)

## ----processcheck, eval=FALSE-------------------------------------------------
#  f <- process_fars(readpath = my_path, years = my_years,
#                    my_state = my_fips, data_check = TRUE)

## ----saving, eval=FALSE-------------------------------------------------------
#  # at this time, the XML file (when working) does not incorporate CDC metadata
#  save_generic(dataset = f,
#               filename = "tract_safety_indicators", savepath = my_path,
#               rds = TRUE, xml = FALSE, shp = TRUE, csv = TRUE)

