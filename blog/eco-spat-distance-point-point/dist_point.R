
# devtools::install_github("ipeaGIT/geobr", subdir = "r-package")

library(tidyverse)
library(sf)
library(geobr)
library(maps)
library(tmap)

sf_use_s2(FALSE)

rc <- geobr::read_municipality(code_muni = 3543907, year = 2020) %>%
    sf::st_transform(crs = 31983)
rc

tm_shape(rc) +
    tm_polygons()

set.seed(42)
pt <- sf::st_sample(rc, 50) %>%
    sf::st_as_sf() %>%
    dplyr::mutate(id = paste0("id", 1:nrow(pt)))
pt

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt) +
    tm_bubbles(size = .3)

pt_buffer <- sf::st_buffer(pt, dist = 1000) %>%
    dplyr::mutate(idb = sub("id", "idb", id)) %>%
    dplyr::select(-id)
pt_buffer

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer) +
    tm_borders() +
    tm_shape(pt) +
    tm_bubbles(size = .3)

pt_join <- sf::st_join(pt, pt_buffer)
pt_join

pt_join_count <- pt_join %>%
    sf::st_drop_geometry() %>%
    dplyr::count(id)
pt_join_count

pt_join <- dplyr::left_join(pt_join, pt_join_count)
pt_join

pt_join_unique <- pt_join %>%
    dplyr::filter(n == 1) %>%
    dplyr::mutate(idb = paste0("idb", 1:nrow(.)))
pt_join_unique

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer) +
    tm_borders() +
    tm_shape(pt_join_unique) +
    tm_bubbles(size = .3)

pt_join_cluster <- pt_join %>%
    dplyr::filter(n > 1)
pt_join_cluster

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer) +
    tm_borders() +
    tm_shape(pt_join_cluster) +
    tm_bubbles(size = .3)

pt_buffer_diss <- pt_buffer %>%
    dplyr::filter(idb %in% pt_join_cluster$idb) %>%
    dplyr::left_join(sf::st_drop_geometry(pt_join_cluster[, c(1:2)])) %>%
    sf::st_union() %>%
    sf::st_cast("POLYGON") %>%
    sf::st_as_sf() %>%
    dplyr::mutate(idb = paste0("idb", nrow(pt_join_unique) + 1:nrow(.)))
pt_buffer_diss

pt_join_cluster_buffer_diss <- sf::st_join(distinct(pt_join_cluster[, 1]), pt_buffer_diss)
pt_join_cluster_buffer_diss

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer_diss) +
    tm_borders() +
    tm_shape(pt) +
    tm_bubbles(size = .3) +
    tm_shape(pt_join_cluster_buffer_diss) +
    tm_bubbles(size = .3, col = "red")

pt_join_cluster_centroid <- NULL
for(i in unique(pt_join_cluster_buffer_diss$idb)){

    pt_join_cluster_i <- pt_join_cluster_buffer_diss %>%
        dplyr::filter(idb == i) %>%
        sf::st_union()
    pt_join_cluster_c <- pt_join_cluster_i %>%
        sf::st_centroid() %>%
        sf::st_as_sf() %>%
        dplyr::mutate(idb = i)
    pt_join_cluster_centroid <- dplyr::bind_rows(pt_join_cluster_centroid, pt_join_cluster_c)

}
pt_join_cluster_centroid

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer_diss) +
    tm_borders() +
    tm_shape(pt_join_unique) +
    tm_bubbles(size = .3) +
    tm_shape(pt_join_cluster_centroid) +
    tm_bubbles(size = .3, col = "red")

pt_final <- dplyr::bind_rows(pt_join_unique, pt_join_cluster_centroid)
pt_final

tm_shape(rc) +
    tm_polygons() +
    tm_shape(pt_buffer_diss) +
    tm_borders() +
    tm_shape(pt_final) +
    tm_bubbles(size = .3)

sf::st_write(pt_final, "pt_final.shp")
