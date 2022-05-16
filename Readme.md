# Community Design Indicator Processing Package (CDIPP)

This package was developed by Abigail Stamm (NYS) with coding and documentation assistance from Eleni Mora (UT) and Margaret Horton (CO). At present, it includes the traffic fatality and poverty indicators, which both are functional, but require further testing. 

In attempts to compile the package, all traffic safety functions (FARS and poverty) have been converted to sf. I left sp and rgeos out of imports, since I want to remove all reference to them, so at the moment, I still get a warning that they should be imported since not all intersection density functions have been converted yet. If you compile the package, please ignore this for now - or convert that bit to sf. I also removed the magrittr import - I'll see if it throws any errors.

Working and converted to sf:

* All FARS and poverty functions. To access them, run:
    * `process_fars()`: calculate vehicle-related deaths by tract
    * `process_poverty()`: calculate poverty by tract
* The following intersection density functions (not yet exported as the indicator is incomplete):
    * `read_land_areas()`: read in protected land
    * `read_water_areas()`: read in all water bodies
    * read_streets()

Needed updates:

* convert count_intersection.R to sf
* add Roxygen for some functions (note which ones)
* add examples for key (exported) functions (`process_fars`, `process_poverty`, `save_generic` so far)
* add option for using FARS API in `read_fars` (and, correspondingly, `process_fars`)
* add and/or revise vignettes (only traffic safety and poverty done, but they're bare-bones)
* flesh out the package help page (if you type `?cdccommdes`)
    * will need feedback from others on authorship and attribution (see [gatpkg](https://ajstamm.github.io/gatpkg/docs/dev/reference/gatpkg.html) for an example)
* figure out the license (I have copied [GAT's MIT license](https://github.com/ajstamm/gatpkg/blob/master/LICENSE), but who is the copyright holder?)
* decide on the package name 
    * will take a little while to overhaul everything
    * maybe have something to do with traffic or transportation, and not be based on the group name
    * or plan to expand the package as more indicators are added
* Package future
    * Who will host it?
    * Who will maintain it?



