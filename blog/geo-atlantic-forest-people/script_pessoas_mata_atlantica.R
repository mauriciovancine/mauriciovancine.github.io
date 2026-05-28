#' ----
#' title: quantas pessoas vivem na mata atlantica
#' author: mauricio vancine
#' date: 2026-05-25
#' ----

# prepare r ---------------------------------------------------------------

# packages
library(tidyverse)
library(sf)
library(geobr)
library(brpop) # remotes::install_github("rfsaldanha/brpop")
library(atlanticr) # remotes::install_github("mauriciovancine/atlanticr")
library(tmap)

# options
options(timeout = 1e5)

# download data -----------------------------------------------------------

## mata atlantica ----
mata_atlantica_2004 <- geobr::read_biomes(year = 2004) %>% 
    dplyr::filter(name_biome == "Mata Atlântica")
mata_atlantica_2004

tm_shape(mata_atlantica_2004) + 
    tm_polygons()

mata_atlantica_2019 <- geobr::read_biomes(year = 2019) %>% 
    dplyr::filter(name_biome == "Mata Atlântica")
mata_atlantica_2019

tm_shape(mata_atlantica_2019) + 
    tm_polygons()

mata_atlantica_2006 <- sf::st_read("https://github.com/mauriciovancine/atlantic-forest-limits/raw/refs/heads/main/atlantic_forest_limit_law_2006/atlantic_forest_limit_law_2006_limit.gpkg") %>% 
    sf::st_transform(sf::st_crs(mata_atlantica_2019))
mata_atlantica_2006

tm_shape(mata_atlantica_2006) + 
    tm_polygons()

## brasil ----
brasil_mun <- geobr::read_municipality(year = 2021) %>% 
    dplyr::mutate(code_muni = as.numeric(str_sub(as.character(code_muni), 1, 6)))
brasil_mun

tm_shape(brasil_mun) + 
    tm_polygons()

## populacao brasil
brasil_pop <- brpop::mun_pop_totals(source = "datasus")
brasil_pop

brasil_pop_wide <- brasil_pop %>% 
    dplyr::filter(year == 2021) %>% 
    dplyr::mutate(year = paste0("pop_", year)) %>% 
    tidyr::pivot_wider(id_cols = code_muni, names_from = year, values_from = "pop")
brasil_pop_wide

## join ----
brasil_mun_pop <- dplyr::left_join(brasil_mun, brasil_pop_wide)
brasil_mun_pop

## filtrar municipios da mata atlantica ----
brasil_mun_pop_mata_atlantica_2004 <- brasil_mun_pop[mata_atlantica_2004, ]
brasil_mun_pop_mata_atlantica_2004

tm_shape(brasil_mun_pop_mata_atlantica_2004) + 
    tm_fill(fill = "pop_2021",
            fill.scale = tm_scale_continuous_log1p(values = "viridis"),
            fill.legend = tm_legend(
                title = "População 2021", 
                position = tm_pos_in("right", "bottom"), 
                frame = TRUE)) + 
    tm_shape(mata_atlantica_2004) + 
    tm_borders(col = "red")

brasil_mun_pop_mata_atlantica_2019 <- brasil_mun_pop[mata_atlantica_2019, ]
brasil_mun_pop_mata_atlantica_2019

tm_shape(brasil_mun_pop_mata_atlantica_2019) + 
    tm_fill(fill = "pop_2021",
            fill.scale = tm_scale_continuous_log1p(values = "viridis"),
            fill.legend = tm_legend(
                title = "População 2021", 
                position = tm_pos_in("right", "bottom"), 
                frame = TRUE)) + 
    tm_shape(mata_atlantica_2019) + 
    tm_borders(col = "red")

brasil_mun_pop_mata_atlantica_2006 <- brasil_mun_pop[mata_atlantica_2006, ]
brasil_mun_pop_mata_atlantica_2006

tm_shape(brasil_mun_pop_mata_atlantica_2006) + 
    tm_fill(fill = "pop_2021",
            fill.scale = tm_scale_continuous_log1p(values = "viridis"),
            fill.legend = tm_legend(
                title = "População 2021", 
                position = tm_pos_in("right", "bottom"), 
                frame = TRUE)) + 
    tm_shape(mata_atlantica_2006) + 
    tm_borders(col = "red")

## populacao na mata atlantica ----
sum(brasil_mun_pop_mata_atlantica_2004$pop_2021)/sum(brasil_mun_pop$pop_2021) * 100
sum(brasil_mun_pop_mata_atlantica_2019$pop_2021)/sum(brasil_mun_pop$pop_2021) * 100
sum(brasil_mun_pop_mata_atlantica_2006$pop_2021)/sum(brasil_mun_pop$pop_2021) * 100
