.onLoad <- function(libname, pkgname){
  if (is.null(getOption("NBA_api_base"))) {
  default_base <- "http://www.basketball-reference.com"
  options("NBA_api_base" = default_base)
  }
}
