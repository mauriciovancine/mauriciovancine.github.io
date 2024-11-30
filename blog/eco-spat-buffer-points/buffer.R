# packages
library(tidyverse)
library(terra)

# points
pts <- tibble::tibble(x = sample(seq(40, 43, .01), 100, rep = TRUE), 
                      y = sample(seq(20, 23, .01), 100, rep = TRUE))
pts

plot(pts$x, pts$y)

# vector
pts_v <- terra::vect(pts, geom = c("x", "y"), crs = "EPSG:4326")
pts_v

plot(pts_v)

# central point
pts_c <- terra::vect(tibble::tibble(x = mean(pts$x), y = mean(pts$y)), 
                     geom = c("x", "y"), crs = "EPSG:4326")
pts_c

plot(pts_v)
plot(pts_c, col = "red", cex = 2, add = TRUE)

# buffers
b <- 1000
pts_included <- 0
while(pts_included < nrow(pts)){
    
    pts_c_b <- terra::buffer(pts_c, b)
    
    pts_included <- nrow(terra::intersect(pts_v, pts_c_b))
    
    plot(pts_c_b)
    plot(pts_v, add = TRUE)
    plot(pts_c, col = "red", cex = 2, add = TRUE)

    b <- b + 1000
    
}
b
