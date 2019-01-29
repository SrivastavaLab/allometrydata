##' Download the allometry data set from SrivastavaLab/allometrydata
##'  (\url{https://github.com/SrivastavaLab/allometrydata/})
##' @title Download allometry data set
##'
##' @param version Version number.  The default will load the most
##'   recent version on your computer or the most recent version known
##'   to the package if you have never downloaded the data before.
##'   With \code{alldata_del}, specifying \code{version = NULL} will
##'   delete \emph{all} data sets.
##'
##' @param path Path to store the data at.  If not given,
##'   \code{datastorr} will use \code{rappdirs} to find the best place
##'   to put persistent application data on your system.  You can
##'   delete the persistent data at any time by running
##'   \code{alldata_del(NULL)} (or \code{alldata_del(NULL, path)} if you
##'   use a different path).
##'
##' @export
alldata <- function(version = NULL, path = NULL) {
  datastorr::github_release_get(alldata_info(path), version)
}

##' @export
##' @rdname alldata
##'
##' @param local Logical indicating if local or github versions should
##'   be polled.  With any luck, \code{local = FALSE} is a superset of
##'   \code{local = TRUE}.  For \code{alldata_version_current}, if
##'   \code{TRUE}, but there are no local versions, then we do check
##'   for the most recent github version.
##'
alldata_versions <- function(local = TRUE, path = NULL) {
  datastorr::github_release_versions(alldata_info(path), local)
}

##' @export
##' @rdname alldata
alldata_version_current <- function(local = TRUE, path = NULL) {
  datastorr::github_release_version_current(alldata_info(path), local)
}

##' @export
##' @rdname alldata
alldata_del <- function(version, path = NULL) {
  datastorr::github_release_del(alldata_info(path), version)
}

## Core data:
alldata_info <- function(path) {
  datastorr::github_release_info("SrivastavaLab/allometrydata",
                                 filename = NULL,
                                 read = readRDS,
                                 path = path)
}