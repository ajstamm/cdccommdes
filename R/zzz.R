# Package structure functions ----
# copied and modified from gatpkg
#' @import      methods

# settings when package is loaded (by calling library())
# or by calling devtools::load_all?
.onLoad <- function(libname, pkgname) {
  op <- options()
  op.devtools <- list(
    devtools.path = "~/R-cdccommdes",
    devtools.install.args = "",
    devtools.name = "Community Design Indicators 2021",
    devtools.desc.author = "Abigail Stamm <abigail.stamm@health.ny.gov> [aut, cre]",
    devtools.desc.license = "MIT License",
    devtools.desc.suggests = NULL,
    devtools.desc = list()
  )
  toset <- !(names(op.devtools) %in% names(op))
  if(any(toset)) options(op.devtools[toset])

  invisible()
}

# settings when package is unloaded (needs to be defined)
# .onUnload()
