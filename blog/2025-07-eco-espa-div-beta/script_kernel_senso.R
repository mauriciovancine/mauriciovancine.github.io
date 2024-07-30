# packages
library(tidyverse)
library(janitor)
library(sf)
library(terra)
library(geobr)
library(SpatialKDE)
library(tmap)

# municipality
sp <- geobr::read_municipality(code_muni = 3550308, year = 2022) %>% 
    sf::st_transform(crs = 31983)
sp

tm_shape(sp) +
    tm_polygons()

# download senso
download.file(url = "https://ftp.ibge.gov.br/Cadastro_Nacional_de_Enderecos_para_Fins_Estatisticos/Censo_Demografico_2022/Coordenadas_enderecos/Municipio/35_SP/3550308.zip", 
              destfile = "Downloads/3550308.zip", mode = "wb")

unzip(zipfile = "Downloads/3550308.zip", exdir = "Downloads/")

# import senso
sp_ibge_senso <- readr::read_csv2("Downloads/3550308.csv") %>% 
    janitor::clean_names() %>% 
    dplyr::filter(cod_especie %in% c(4, 5, 8),
                  nv_geo_coord %in% c(1, 2)) %>% 
    dplyr::mutate(latitude = latitude/1e6,
                  longitude = longitude/1e6)
sp_ibge_senso

# vector senso
sp_ibge_senso_sf <- sf::st_as_sf(sp_ibge_senso, coords = c("longitude", "latitude"), crs = 4326) %>% 
    sf::st_transform(crs = 31983)
sp_ibge_senso_sf

tm_shape(sp) +
    tm_polygons() +
    tm_shape(sp_ibge_senso_sf) +
    tm_bubbles(col = "cod_especie", style = "cat", size = .3) +
    tm_grid()

sp_ibge_senso_sf_ensino <- sp_ibge_senso_sf %>%
    dplyr::filter(cod_especie == 4)
sp_ibge_senso_sf_ensino

sp_ibge_senso_sf_saude <- sp_ibge_senso_sf %>%
    dplyr::filter(cod_especie == 5)
sp_ibge_senso_sf_saude

sp_ibge_senso_sf_religioso <- sp_ibge_senso_sf %>%
    dplyr::filter(cod_especie == 8)
sp_ibge_senso_sf_religioso

# kernel ------------------------------------------------------------------

# cell size and band width
cell_size <- 500
band_width <- 1000

# grid
sp_raster <- sp %>% 
    SpatialKDE::create_raster(cell_size = cell_size, side_offset = band_width)
sp_raster

# kde ----
sp_ibge_senso_ensino_kde <- sp_ibge_senso_sf_ensino %>%
    dplyr::select(geometry) %>% 
    SpatialKDE::kde(band_width = band_width, 
                    kernel = "quartic", 
                    grid = sp_raster) %>% 
    terra::rast() %>% 
    terra::crop(sp, mask = TRUE)
sp_ibge_senso_ensino_kde
plot(sp_ibge_senso_ensino_kde)

sp_ibge_senso_saude_kde <- sp_ibge_senso_sf_saude %>%
    dplyr::select(geometry) %>% 
    SpatialKDE::kde(band_width = band_width, 
                    kernel = "quartic", 
                    grid = sp_raster) %>% 
    terra::rast() %>% 
    terra::crop(sp, mask = TRUE)
sp_ibge_senso_saude_kde
plot(sp_ibge_senso_saude_kde)

sp_ibge_senso_religioso_kde <- sp_ibge_senso_sf_religioso %>%
    dplyr::select(geometry) %>% 
    SpatialKDE::kde(band_width = band_width, 
                    kernel = "quartic", 
                    grid = sp_raster) %>% 
    terra::rast() %>% 
    terra::crop(sp, mask = TRUE)
sp_ibge_senso_religioso_kde
plot(sp_ibge_senso_religioso_kde)

# mapas ----
mapa_kde_educacao <- tm_shape(sp_ibge_senso_ensino_kde) +
    tm_raster(col.scale = tm_scale_continuous(values = "-Spectral"),
              col.legend = tm_legend(title = "Kernel educação", 
                                     position = tm_pos_in("right", "bottom"))) +
    tm_shape(sp) +
    tm_borders() +
    tm_grid(lines = FALSE) 
mapa_kde_educacao

mapa_kde_educacao_igual <- tm_shape(sp_ibge_senso_ensino_kde) +
    tm_raster(col.scale = tm_scale_continuous(limits = c(0, 200), values = "-Spectral"),
              col.legend = tm_legend(title = "Kernel educação", 
                                     position = tm_pos_in("right", "bottom"))) +
    tm_shape(sp) +
    tm_borders() +
    tm_grid(lines = FALSE) 
mapa_kde_educacao

mapa_kde_saude <- tm_shape(sp_ibge_senso_saude_kde) +
    tm_raster(col.scale = tm_scale_continuous(values = "-Spectral"),
              col.legend = tm_legend(title = "Kernel saúde", 
                                     position = tm_pos_in("right", "bottom"))) +
    tm_shape(sp) +
    tm_borders() +
    tm_grid(lines = FALSE) 
mapa_kde_saude

mapa_kde_saude_igual <- tm_shape(sp_ibge_senso_saude_kde) +
    tm_raster(col.scale = tm_scale_continuous(limits = c(0, 200), values = "-Spectral"),
              col.legend = tm_legend(title = "Kernel saúde", 
                                     position = tm_pos_in("right", "bottom"))) +
    tm_shape(sp) +
    tm_borders() +
    tm_grid(lines = FALSE) 
mapa_kde_saude_igual
    
mapa_kde_religiao <- tm_shape(sp_ibge_senso_religioso_kde) +
    tm_raster(col.scale = tm_scale_continuous(values = "-Spectral"),
              col.legend = tm_legend(title = "Kernel religião", 
                                     position = tm_pos_in("right", "bottom"))) +
    tm_shape(sp) +
    tm_borders() +
    tm_grid(lines = FALSE) 
mapa_kde_religiao

mapa_kde_religiao_igual <- tm_shape(sp_ibge_senso_religioso_kde) +
    tm_raster(col.scale = tm_scale_continuous(limits = c(0, 200), values = "-Spectral"),
              col.legend = tm_legend(title = "Kernel religião", 
                                     position = tm_pos_in("right", "bottom"))) +
    tm_shape(sp) +
    tm_borders() +
    tm_grid(lines = FALSE) 
mapa_kde_religiao_igual

mapa <- tmap_arrange(mapa_kde_educacao, mapa_kde_saude, mapa_kde_religiao)
mapa

mapa_igual <- tmap_arrange(mapa_kde_educacao_igual, mapa_kde_saude_igual, mapa_kde_religiao_igual)
mapa_igual

tmap_save(mapa, paste0("Downloads/map_kernel.png"), 
          wi = 30, he = 20, un = "cm", dpi = 300)

tmap_save(mapa_igual, paste0("Downloads/map_kernel_igual.png"), 
          wi = 30, he = 20, un = "cm", dpi = 300)
