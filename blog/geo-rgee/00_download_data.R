#' ----
#' title: download covariates
#' author: mauricio vancine
#' date: 2022-10-14
#' ----

# packages
library(tidyverse)
library(terra)
library(sf)
library(mapview)
library(rgee)
library(reticulate)


# config rgee -------------------------------------------------------------

# examples
# https://r-earthengine.github.io/
# https://r-spatial.github.io/rgee/articles/rgee05.html

# install gee
# rgee::ee_install()

# check install
rgee::ee_check()

# init gee
# sudo snap install google-cloud-cli --classic
rgee::ee_Initialize()
rgee::ee_user_info()

# import points atlantic amphibians ---------------------------------------

# import
aa <- readr::read_csv("../01_communities/01_data/ATLANTIC_AMPHIBIANS_sites_fix.csv") |>
  dplyr::select(id, longitude, latitude)
aa

# vetor
aa_v <- sf::st_as_sf(aa, coords = c("longitude", "latitude"), crs = 4326)
aa_v

# import collection -------------------------------------------------------

# mapbiomas brasil
mapbiomas_brasil <- ee$ImageCollection("projects/mapbiomas-workspace/public/collection7/mapbiomas_collection70_integration_v2")
mapbiomas_brasil

# extract
aa_v_mapbiomas <- rgee::ee_extract(x = mapbiomas_brasil, y = aa_v[1:10, ], sf = FALSE)
aa_v_mapbiomas

# plot
Map$addLayer(mapbiomas_brasil, , "mapbiomas")
