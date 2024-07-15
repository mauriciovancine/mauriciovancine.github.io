
# devtools::install_github("ipeaGIT/geobr", subdir = "r-package")

library(tidyverse)
library(sf)
library(geobr)
library(maps)
library(tmap)

rc <- geobr::read_municipality(code_muni = 3543907, year = 2020) %>%
    sf::st_transform(crs = 31983)
rc

tm_shape(rc) +
    tm_polygons()

set.seed(42)
pt <- sf::st_sample(rc, 10) %>%
    sf::st_as_sf() %>%
    dplyr::mutate(id = paste0("id", 1:10)) %>% 
    dplyr::mutate(dist_buffer = sample(100:1000, 10))
pt

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt) +
    tm_bubbles(size = .3)

pt_buffer <- sf::st_buffer(pt, dist = pt$dist_buffer)
pt_buffer

point_buffer <- purrr::map_dfr(c(seq(200, 2000, 200), 2500), ~sf::st_buffer(point_utm, .x))

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer) +
    tm_borders() +
    tm_shape(pt) +
    tm_bubbles(size = .3)

sf::st_write(pt_buffer, "pt_buffer.shp")
