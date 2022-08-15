# Community Design Indicator Processing Package (CDIPP)

This package was developed by Abigail Stamm (NYS) with coding and documentation assistance from Eleni Mora (UT) and Margaret Horton (CO). At present, it includes the traffic fatality and poverty indicators, which both are functional, but require further testing. 

In attempts to compile the package, all traffic safety functions (FARS and poverty) have been converted to sf. I removed the magrittr import - I'll see if it throws any errors.

Working and converted to sf:

* All FARS and poverty functions. To access them, run:
    * `process_fars()`: calculate vehicle-related deaths by tract
    * `process_poverty()`: calculate poverty by tract
* The following intersection density functions (not yet exported as the indicator is incomplete):
    * `read_land_areas()`: read in protected land
    * `read_water_areas()`: read in all water bodies
    * read_streets()
* The following VMT functions (not yet exported as the indicator is incomplete):
    * `read_tracts()`: read census tracts
    * `prep_arc_aadt()`: read ArcGIS Online data

Needed updates:

* Look into using the package `osmdata` to read OpenStreetMap?
    * Reasons Abby doesn't think this will work: 
        1. This package uses OSM's API to pull all objects that overlap a literal box around a user-defined geography. As a result, when I pull data for, say, Staten Island in NYC, I also get objects in NJ close to Staten Island. On the plus side, it's easy to deduplicate if you pull two neighboring areas, since the package pulls objects that intersect the box without clipping them to fit inside the box first, but it pulls a lot of unnecessary data.
        2. Pulling all of NYS at once timed out, so in my test functions, I used the `tigris` function to create loops to pull data county by county. Even with pauses within the loops to slow down pings to the API, I have yet to successfully pull street data for Suffolk County, NY using this package. (Weirdly, NYC was fine county by county.) 
    * Abby recommends skipping this package for now.
* in `save_generic()` the XML portion broke and will give an error - it needs to be investigated
* convert count_intersection.R to sf - done?
* add Roxygen for some functions (note which ones)
* add examples for key (exported) functions (`process_fars`, `process_poverty`, `save_generic` so far)
* add option for using FARS API in `read_fars` (and, correspondingly, `process_fars`)
* add and/or revise vignettes (only traffic safety and poverty done, but they're bare-bones)
* flesh out the package help page (if you type `?cdccommdes`)
* package name: keep cdccommdes and add new indicators as available
* Package future: Aaron is looking into this. Abby and Margaret think CDC should be copyright holder. Not sure about hosting, but maintenance may fall under SND umbrella at some point (Margaret and Abby at the moment, though)
    * Who will host it?
    * Who will maintain it?
* add acknowledgements, funder, license as CDC
    * will need feedback from others on authorship and attribution (see [gatpkg](https://ajstamm.github.io/gatpkg/docs/dev/reference/gatpkg.html) for an example)
    * figure out the license (I have copied [GAT's MIT license](https://github.com/ajstamm/gatpkg/blob/master/LICENSE), but who is the copyright holder?)


## Acknowledgements

The development of this package would not have been possible without the support of the Centers for Disease Control and Prevention (CDC) National Environmental Health Tracking Program (NEPHT), especially the Community Design Content Workgroup. Its content is solely the responsibility of the authors and does not necessarily represent the official views of the CDC.
