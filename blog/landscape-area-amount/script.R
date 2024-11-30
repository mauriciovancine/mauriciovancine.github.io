# packages
library(tidyverse)
library(terra)
library(landscapemetrics)
library(NLMR)
library(viridis)

# landscape
landscape <- terra::rast(NLMR::nlm_mosaictess(500, 500, germs = 2000))
landscape

landscape_bin <- terra::ifel(landscape >= .7, 1, 0)
landscape_bin

landscape_na <- terra::ifel(landscape >= .7, 1, NA)
landscape_na

plot(landscape, col = viridis::viridis(100))
plot(landscape_bin, col = c("gray90", "forestgreen"))
plot(landscape_na, col = "forestgreen")

# points
set.seed(42)
po <- terra::spatSample(x = landscape_bin, size = 10, method = "random", as.points=TRUE)
po

bu <- terra::buffer(x = po, width = 20)
bu

plot(landscape_na, col = "forestgreen")
plot(po, add = TRUE)
plot(bu, add = TRUE)

# area
landscape_area <- landscapemetrics::spatialize_lsm(landscape_na, metric = "area")$layer_1$lsm_p_area
landscape_area

plot(landscape_area, col = viridis::viridis(100))
plot(po, add = TRUE)
text(po, col = "red", cex = 1, pos = 1)
plot(bu, add = TRUE)

# metrics
metrics <- c(20) %>%
    purrr::set_names() %>%
    purrr::map_dfr(~sample_lsm(landscape = landscape_bin,
                               y = po,
                               shape = "circle",
                               size = .,
                               what = c(
                                   "lsm_c_pland",
                                   "lsm_c_area_mn"),
                               return_raster = FALSE,
                               verbose = TRUE,
                               progress = TRUE),
                   .id = "buffer") %>% 
    dplyr::filter(class == 1) %>% 
    dplyr::select(plot_id, metric, value) %>% 
    tidyr::pivot_wider(names_from = metric, values_from = value)
metrics

# extract
bu_area <- terra::zonal(landscape_area, bu[-8,], mean, na.rm = TRUE) %>% 
    tibble::as_tibble() %>% 
    dplyr::rename(area_buffer = value)
bu_area

# final
metrics_final <- cbind(metrics, bu_area)
metrics_final

ggplot(metrics_final, aes(x = area_mn, y = area_buffer)) +
    geom_point(size = 5, color = "gray") +
    labs(x = "Área média dentro do buffer", y = "Área média fora do buffer") +
    theme_classic(base_size = 20)

ggplot(metrics_final, aes(x = pland, y = area_mn)) +
    geom_point(size = 5, color = "gray") +
    labs(x = "Quantidade de habitat (%)", y = "Área média dentro do buffer") +
    theme_classic(base_size = 20)

ggplot(metrics_final, aes(x = pland, y = area_buffer)) +
    geom_point(size = 5, color = "gray") +
    labs(x = "Quantidade de habitat (%)", y = "Área média fora do buffer") +
    theme_classic(base_size = 20)
