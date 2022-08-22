# cdccommdes v0.1.6

* Removed dependency on kulife package as it does not work with R v4.2.
* Addressed warnings in `read_tract()` and `prep_arc_aadt()`.
* Changed FARS and tract variable names to lower case when reading in to simplify code.
* Aligned all variable names in the final FARS dataset with the revised how-to guide.

# cdccommdes v0.1.5 (2022-05-16)

* Standardized function names and options for `read_streets()`, `read_water_areas()`, and `read_land_areas()`. Added option to save the resulting layer for all three.
* Changed map drawn in `process_fars()` data check from base R to leaflet.
* Rewrote `process_fars()` to use the same `read_tract()` function as the AADT indicator, which uses the tigris package.
* Updated license and copyright information.

# cdccommdes v0.1.4 (2022-04-19)

* Made data check map in `process_fars()` more informative by adding an underlying choropleth.
* Revised `process_fars()` to output an `sf` object.
* Added `classInt` package as a dependency.

# cdccommdes v0.1.3 (2022-04-14)

* Added CSV and shapefile save options to `save_generic()`.
* Revised `process_poverty()` to output an `sf` object.

# cdccommdes v0.1.2 (2022-03-22)

* In `process_poverty()`, removed an unused option and added population poverty.
* Added a vignette for creating the poverty indicator.
* Added package help documentation (when typing `?cdccommdes`).
* Minor documentation edits.

# cdccommdes v0.1.1 (2022-03-17)

* Added a vignette for creating the traffic fatality indicators.
* Minor documentation edits.

# cdccommdes v0.1.0 (2022-03-15)

* First compilation with traffic safety indicators and bare-bones documentation.

