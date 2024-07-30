# packages
library(geobr)
library(sf)
library(fasterize)
library(terra)
library(dplyr)
library(tmap)
library(landscapetools)
library(landscapemetrics)

# rio claro
rc <- geobr::read_municipality(code_muni = 3543907, year = 2013) |>  
    sf::st_transform(crs = 31983)
rc

tm_shape(rc) +
    tm_polygons()

# download land cover
for(i in c(".dbf", ".prj", ".shp", ".shx")){
    download.file(url = paste0("http://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO", i),
                  destfile = paste0("content/blog/eco-pai-metricas-base/data/SP_3543907_USO", i), mode = "wb")
}

# import land use
rc_lu <- sf::st_read("content/blog/eco-pai-metricas-base/data/SP_3543907_USO.shp", quiet = TRUE) |> 
    dplyr::mutate(CLASSE_USO = forcats::as_factor(CLASSE_USO))
rc_lu

tm_shape(rc_lu) +
    tm_fill(col = "CLASSE_USO",
            pal = c("blue", "orange", "gray", "forestgreen", "green"))

# rasterize
r <- fasterize::raster(rc_lu, res = 30)
rc_lur <- fasterize::fasterize(rc_lu, r, field = "CLASSE_USO") |> 
    terra::rast()
rc_lur

tm_shape(rc_lur) +
    tm_raster(style = "cat",
              pal = c("blue", "orange", "gray", "forestgreen", "green"))

# points
set.seed(42)
rc_po <- sf::st_sample(rc, 3) |> 
    sf::st_as_sf()
rc_po

tm_shape(rc_lur) +
    tm_raster(style = "cat",
              pal = c("blue", "orange", "gray", "forestgreen", "green")) +
    tm_shape(rc_po) +
    tm_bubbles()

# check raster
landscapemetrics::check_landscape(rc_lur)

# buffers
rc_po1_bf <- sf::st_buffer(rc_po[1, ], 1000)
rc_po2_bf <- sf::st_buffer(rc_po[2, ], 1000)
rc_po3_bf <- sf::st_buffer(rc_po[3, ], 1000)

# landscapes
rc_lc1 <- terra::mask(terra::crop(rc_lur, terra::vect(rc_po1_bf)), terra::vect(rc_po1_bf))
rc_lc2 <- terra::mask(terra::crop(rc_lur, terra::vect(rc_po2_bf)), terra::vect(rc_po2_bf))
rc_lc3 <- terra::mask(terra::crop(rc_lur, terra::vect(rc_po3_bf)), terra::vect(rc_po3_bf))

tm_shape(rc_lc1) +
    tm_raster(style = "cat",
              pal = c("blue", "orange", "forestgreen")) +
    tm_shape(rc_po1_bf) +
    tm_borders()

tm_shape(rc_lc2) +
    tm_raster(style = "cat",
              pal = c("blue", "orange", "forestgreen")) +
    tm_shape(rc_po2_bf) +
    tm_borders()

tm_shape(rc_lc3) +
    tm_raster(style = "cat",
              pal = c("blue", "orange", "forestgreen", "green")) +
    tm_shape(rc_po3_bf) +
    tm_borders()

# pid
rc_lc1_pid_dir4 <- landscapemetrics::get_patches(rc_lc1, class = 4, directions = 4)
rc_lc1_pid_dir8 <- landscapemetrics::get_patches(rc_lc1, class = 4, directions = 8)

landscapetools::show_landscape(rc_lc1_pid_dir4$layer_1)
landscapetools::show_landscape(rc_lc1_pid_dir8$layer_1)

# number of patches ----
rc_lc1_np <- landscapemetrics::lsm_c_np(rc_lc1, directions = 8)
rc_lc1_np
    
# percentage of landscape ----
rc_lc1_pl <- landscapemetrics::lsm_c_pland(rc_lc1, directions = 8)
rc_lc1_pl

# patch density ----
rc_lc1_pd <- landscapemetrics::lsm_c_pd(rc_lc1, directions = 8)
rc_lc1_pd

# edge density ----
rc_lc1_ed <- landscapemetrics::lsm_c_ed(rc_lc1, directions = 8)
rc_lc1_ed

## enn ----
rc_lc1_na <- rc_lc1
rc_lc1_na[] <- ifelse(values(rc_lc1) == 4, 1, NA)

landscapemetrics::lsm_p_enn(rc_lc1 == 4)
landscapemetrics::lsm_p_enn(rc_lc1_na)

rc_lc1_enn_p <- landscapemetrics::lsm_p_enn(rc_lc1)
rc_lc1_enn_p

rc_lc1_enn_p_spat <- landscapemetrics::spatialize_lsm(rc_lc1, what = "lsm_p_enn")
rc_lc1_enn_p_spat

plot(log10(rc_lc1_enn_p_spat$layer_1$lsm_p_enn), col = viridis::viridis(100))

rc_lc1_enn_c <- landscapemetrics::lsm_c_enn_mn(rc_lc1)
rc_lc1_enn_c

rc_lc1_enn_l <- landscapemetrics::lsm_l_enn_mn(rc_lc1)
rc_lc1_enn_l

## area ----
mapbiomas_1985_forest_l_area_mn <- landscapemetrics::lsm_l_area_mn(mapbiomas_1985_forest_na)

## para ----
mapbiomas_1985_forest_l_para_mn <- landscapemetrics::lsm_l_para_mn(mapbiomas_1985_forest_na)

## cai ----
mapbiomas_1985_forest_l_cai_mn <- landscapemetrics::lsm_l_cai_mn(mapbiomas_1985_forest_na)

## contig ----
mapbiomas_1985_forest_l_contig_mn <- landscapemetrics::lsm_l_contig_mn(mapbiomas_1985_forest_na)

## shape ----
mapbiomas_1985_forest_l_shape_mn <- landscapemetrics::lsm_l_shape_mn(mapbiomas_1985_forest_na)

## np ----
mapbiomas_1985_forest_l_np <- landscapemetrics::lsm_l_np(mapbiomas_1985_forest_na)

## ai ----
mapbiomas_1985_forest_l_ai <- landscapemetrics::lsm_c_ai(mapbiomas_1985_forest)

## ed ----
mapbiomas_1985_forest_l_ed <- landscapemetrics::lsm_l_ed(mapbiomas_1985_forest)

## pd ----
mapbiomas_1985_forest_c_pd <- landscapemetrics::lsm_c_pd(mapbiomas_1985_forest)

## pland ----
mapbiomas_1985_forest_c_pland <- landscapemetrics::lsm_c_pland(mapbiomas_1985_forest)

# pid
rc_lcr_pid <- landscapemetrics::get_patches(rc_lcr, class = 4)
rc_lcr_pid

landscapetools::show_landscape(rc_lcr_pid$layer_1)