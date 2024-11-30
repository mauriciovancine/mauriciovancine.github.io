#' ----
#' title: 
#' author: 
#' date: 
#' operational system: gnu/linux - ubuntu - pop_os
#' ----

# prepare r -------------------------------------------------------------

# packages
library(tidyverse)
library(terra)
library(vroom)
library(parallelly)
library(doParallel)
library(foreach)
library(furrr)
library(future)

# import data -------------------------------------------------------------

# limit
li <- terra::vect("ma_limite_integrador_muylaert_et_al_2018_wgs84_geodesic_v1_2_0.shp")
li

plot(li)

# rasters
r_list <- dir("/media/mude/afe69132-ffdb-4892-b809-a0f7d2b8f423/geospatial_data_base/02_raster/worldclim_2/01_present/30s/", 
              pattern = ".tif$", full.names = TRUE)
r_list

doParallel::registerDoParallel(parallelly::availableCores(omit = 2))
foreach::foreach(i=r_list) %dopar% {
    
    print(i)
    terra::rast(i) %>% 
        terra::crop(li, mask = TRUE) %>% 
        terra::writeRaster(paste0(basename(i)), overwrite = TRUE)

}
doParallel::stopImplicitCluster()

# test
plot(rast("wc2.1_30s_bio_01.tif"))

# raster to data ----------------------------------------------------------

# list
r_list <- dir(pattern = ".tif$")
r_list

# data
doParallel::registerDoParallel(parallelly::availableCores(omit = 2))
foreach::foreach(i=r_list) %dopar% {
    
    print(i)
    terra::rast(i) %>% 
        terra::as.data.frame(cells = TRUE) %>% 
        vroom::vroom_write(paste0(basename(sub(".tif", ".csv", i))), delim = ",")
    
}
doParallel::stopImplicitCluster()

# combine by pixels -------------------------------------------------------

da <- vroom::vroom(file = "wc2.1_30s_bio_01.csv", delim = ",")
da

da_files <- dir(pattern = ".csv$")
da_files

doParallel::registerDoParallel(parallelly::availableCores(omit = 2))
foreach::foreach(i=1:nrow(da)) %dopar% {

    r_data_i <- NULL
    for(j in da_files){
    
        r_data_i_j <- vroom::vroom(file = j, delim = ",", skip = i - 1, n_max = i, 
                                   show_col_types = FALSE, progress = FALSE, num_threads = 6)[1, ]
        r_data_i_j_cell <- r_data_i_j[, 1]
        r_data_i_j_data <- as.data.frame(r_data_i_j[, 2])
        colnames(r_data_i_j_cell) <- "cell"
        colnames(r_data_i_j_data) <- sub(".csv", "", j)
        r_data_i <- bind_cols(r_data_i, r_data_i_j_data)
        
    }
    
    r_data_i <- bind_cols(r_data_i_j_cell, r_data_i)
    
    readr::write_csv(r_data_i, paste0("da/da_r", r_data_i_j_cell[, 1], ".csv"))

    }
doParallel::stopImplicitCluster()

# import and combine ------------------------------------------------------

# list
da_list <- dir(path = "da", full.names = TRUE)
da_list

# import and combine
plan(multisession, workers = parallelly::availableCores(omit = 2))
da_data <- furrr::future_map_dfr(da_list, readr::read_csv, show_col_types = FALSE) %>% 
    dplyr::arrange(cell)
da_data

# end ---------------------------------------------------------------------
