# packages
library(dplyr)
library(readr)
library(sf)
library(sp)
library(rgdal)
library(raster)
library(tmap)
library(geosphere)

# import points
points <- sf::st_read("Downloads/ajudinhacomqgisououtro/pts_estrada_WGS84.shp", 
                  options = "ENCODING=LATIN1") |> 
    sf::as_Spatial()
points

tm_shape(points) +
    tm_dots()
 
# import lines
lines <- sf::st_read("Downloads/ajudinhacomqgisououtro/estrada_WGS84.shp") |> 
    sf::as_Spatial()
lines

tm_shape(points) +
    tm_dots()+
    tm_shape(lines) +
    tm_lines(col = "red", lwd = 2)

# distances
dist <- geosphere::dist2Line(points, lines) |> 
    as.data.frame()
dist

# vectors
lines_total <- NULL
points_total <- NULL

for(i in 1:nrow(points)){
    
    # verify
    print(i)
    
    # filter
    points_i <- sf::st_as_sf(points[i, ])
    dist_i <- sf::st_as_sf(dist[i, 2:3], coords = c("lon", "lat"), crs = 4326)
    lines_i <- sf::st_union(points_i, dist_i) |> 
        sf::st_cast("LINESTRING") |> 
        dplyr::select(geometry) |> 
        dplyr::mutate(dist = dist[i, 1], .before = 1)
    
    # combine
    points_total <- dplyr::bind_rows(points_total, dist_i)
    lines_total <- dplyr::bind_rows(lines_total, lines_i)
    
    }

plot(lines_total$geometry)

tm_shape(points) +
    tm_dots()+
    tm_shape(lines) +
    tm_lines(col = "red", lwd = 2) +
    tm_shape(points_total) +
    tm_dots(col = "forestgreen") +
    tm_shape(lines_total) +
    tm_lines(col = "blue", lwd = 2)

# export
readr::write_csv(dist, "Downloads/ajudinhacomqgisououtro/dist.csv")
sf::st_write(points_total, "Downloads/ajudinhacomqgisououtro/points_total.gpkg", delete_dsn = TRUE)
sf::st_write(lines_total, "Downloads/ajudinhacomqgisououtro/lines_total.gpkg", delete_dsn = TRUE)
