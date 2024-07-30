# packages
library(tidyverse)
library(sf)
library(tmap)
library(lconnect)
library(Makurhini)

# data
download.file("https://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.dbf", "/home/mude/Downloads/SP_3543907_USO.dbf", mode = "wb")
download.file("https://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.prj", "/home/mude/Downloads/SP_3543907_USO.prj", mode = "wb")
download.file("https://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.shp", "/home/mude/Downloads/SP_3543907_USO.shp", mode = "wb")
download.file("https://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO.shx", "/home/mude/Downloads/SP_3543907_USO.shx", mode = "wb")

rc <- sf::st_read("/home/mude/Downloads/SP_3543907_USO.shp") %>%
    dplyr::filter(CLASSE_USO == "formação florestal")

tm_shape(rc) +
    tm_fill(fill = "forestgreen")

set.seed(42)
po <- sf::st_sample(x = rc, size = 10) %>%
    sf::st_buffer(1e3) %>%
    sf::st_as_sf() %>%
    dplyr::mutate(area_ha = sf::st_area(.)/1e4,
                  porcentagem = NA)
po

tm_shape(rc) +
    tm_fill(fill = "forestgreen") +
    tm_shape(po) +
    tm_borders(col = "red")

# habitat amount ----------------------------------------------------------

# habitat amount
rc_po <- NULL
for(i in 1:nrow(po)){
    
    po_i <- po[i,]
    rc_po_i <- sf::st_as_sf(sf::st_union(sf::st_intersection(rc, po_i)))
    rc_po <- rbind(rc_po, rc_po_i)
    rc_po_area <- sf::st_area(rc_po_i)/1e4
    po[i,]$porcentagem <- round(rc_po_area/po[i, ]$area_ha*100, 2)
    
}
po

map_habitat_amount <- tm_shape(rc) +
    tm_fill(fill = "gray") +
    tm_shape(rc_po) +
    tm_fill(fill = "forestgreen") +
    tm_shape(po) +
    tm_borders(col = "red") +
    tm_text(text = "porcentagem")
map_habitat_amount

# export
for(i in 1:nrow(rc_po)){
    
    rc_po[i, ] %>% 
        dplyr::mutate(habitat = 1) %>% 
        sf::st_write(paste0("Downloads/buffer_", i, ".gpkg"), delete_dsn = TRUE)
    
}

# connectivity ------------------------------------------------------------

# lconnec
po$iic <- NA
for(i in 1:nrow(rc_po)){

    land <- lconnect::upload_land(paste0("Downloads/buffer_", i, ".gpkg"), habitat = 1, max_dist = 100)
    po[i,]$iic <- as.numeric(lconnect::con_metric(land, metric = "IIC"))
    
}
po

map_iic <- tm_shape(rc) +
    tm_fill(fill = "gray") +
    tm_shape(rc_po) +
    tm_fill(fill = "forestgreen") +
    tm_shape(po) +
    tm_borders(col = "red") +
    tm_text(text = "iic")
map_iic


# correlation -------------------------------------------------------------

cor(po$porcentagem, po$iic)

po %>% 
    sf::st_drop_geometry() %>% 
    ggplot(aes(porcentagem, iic)) +
    stat_smooth(method = "lm") +
    geom_point(size = 5, color = "gray30") +
    theme_classic(base_size = 25)

# end ---------------------------------------------------------------------
