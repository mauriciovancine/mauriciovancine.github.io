# install.packages("devtools")
# devtools::install_github("mstrimas/metacapa")

library(raster)
library(metacapa)

# generate a network of patches
r <- raster::raster(nrows = 10, ncols = 10, crs = "+proj=aea +lat_1=1 +lat_2=1")
r[] <- round(runif(raster::ncell(r)) * 0.7)
plot(r)

# exponential dispersal kernel
f <- dispersal_negexp(1 / 100)

# calulate the areas and interpatch distances
pc <- patch_config(r, "m")
pc

# metapopulation capacity
meta_capacity(pc, f = f)

# raster
r <- raster::raster(nrows = 10, ncols = 10, crs = "+proj=aea +lat_1=1 +lat_2=1")
r[] <- round(runif(raster::ncell(r)) * 0.7)
patch_config(r, units = "m")

# polygon
p_poly <- raster::rasterToPolygons(r, dissolve = TRUE)
p_poly <- sf::st_as_sf(p_poly)
p_poly <- p_poly[p_poly$layer == 1, ]
p_poly <- sf::st_cast(p_poly, "POLYGON")
patch_config(p_poly, units = "km")


patch_config(x, units = c("m", "km"))


hanski_ic <- function(area, dist, alp, bet){ 
    
    alphmat <- matrix(-alp, 1, 1)
    alphdist <- dist * c(alphmat)
    IC <- (exp(alphdist) %*% (area^bet)) - area^bet
    return(IC)
}

