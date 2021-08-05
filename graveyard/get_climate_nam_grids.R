#' Download raster of climate data for North America
#'
#' @param years vector of selected years (numeric), all years from 1900 until 2018 are available.
#' @param infos character string specifying the data to be downloaded. Available data are "bio", "cmi", "mint", "maxt", "pcp" and "sg" (see details).
#' @param res resolution of the raster files to be downloaded in arcsec (60 or 300arcsec, i.e. 10km2 or 2km2), default is set to 300.
#' @param path path to the folder where files are or will be stored.
#' @param geom geometry used for extraction.
#' @param pattern a regular expression. Only file names which match the regular expression will be returned (see [list.files()]).
#' @param ... additional parameters to be passed to [list.files()].
#'
#' @details
#' * `bio` : 19 bioclimatic variables,
#' * `cmi` : monthly Climate Moisture Index,
#' * `mint`: monthly minimum temperature,
#' * `maxt`: monthly maximum temperature,
#' * `pcp` : monthly precipitation,
#' * `sg`  : 16 additional bioclimatic variables.
#'
#' @references
#' <ftp://ftp.nrcan.gc.ca/pub/outgoing/NAM_grids>
#' <https://climate.weather.gc.ca/>
#'
#' @export
#' @examples
#' \dontrun{
#'  get_climate_nam_grids(2018)
#'  get_climate_nam_grids(2009:2018, c("maxt", "mint", "pcp"))
#'  # extract_climate_data("2018", get_gadm('CAN', 1)[9, ], full.names = TRUE)
#' }
#' 

if (!require("remotes")) install.packages("remotes")
if (!require("iseDataRetrieval")) remotes::install_github("inSileco/iseDataRetrieval")
if (!require("inSilecoMisc")) remotes::install_github("inSileco/inSilecoMisc")
if (!require("cli")) install.packages("cli")

library(iseDataRetrieval)
library(inSilecoMisc)
library(cli)



dl_check <- function(url, destfile, ...) {
  if (file.exists(destfile)) {
    msgWarning("skipped (already dowloaded)")
  } else {
    msgInfo("Accessing", url)
    curl::curl_download(url, destfile, ...)
    msgSuccess("file downloaded!")
  }
  invisible(TRUE)
}



get_climate_nam_grids <- function(years, infos = "bio", res = 300, path = ".") {

  stopifnot(all(infos %in% c("bio", "cmi", "mint", "maxt", "pcp", "sg")))
  infos <- unique(infos)
  stopifnot(res %in% c(60, 300))
  #
  basurl <- "ftp://ftp.nrcan.gc.ca/pub/outgoing/NAM_grids/zipfiles"
  beg <- paste0(basurl, res, "/")
  end <- paste0("_", res, "arcsec.zip")
  # year available: from 1900 to 2017
  for (info in infos) {
    msgInfo("Downloading grids of", style_bold(info))

    for (year in years) {
      msgInfo("info:", style_bold(info), cli::symbol$arrow_right, "year:",
        style_bold(year), " ", appendLF = FALSE)
      zout <- tempfile(fileext = ".zip")
      dl_check(paste0(beg, info, year, end), destfile = zout)
      unzip(zout, exdir = path)
      unlink(zout)
    }
  }

  invisible(0)
}


#' @describeIn get_climate_nam_grids extract data from a nam grid.
#' @examples
#' \dontrun{
#' can <- get_gadm("CAN", level = 1, format = "sf")  
#' get_climate_nam_grids(1990:1991, c("bio")) 
#' geom <- readRDS("gadm36_CAN_1_sf.rds")
#' extract_climate_data("1990", geom)
#' }
#' @export

extract_climate_data <- function(path, geom, pattern = "\\.asc$|\\.tif$", ...) {
  fls <- list.files(path, pattern = pattern, full.names = TRUE, ...)
  print(fls)
  nmc <- nmc <- gsub("\\..*","",basename(fls))
  out <- lapply(lapply(fls, raster), 
    function(x) extract(crop(x, y =  geom), y =  geom))
  names(out) <- nmc
  out
}



#get_climate_nam_grids(2016:2018, c("bio", "cmi", "mint", "pcp"))


