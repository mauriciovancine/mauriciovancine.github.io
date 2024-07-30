setwd("/home/mude/data/github/mauriciovancine/apero/content/blog/eco-pai-lconnect/")

# packages
# install.packages("lconnect", dependencies = TRUE)
library(lconnect)
library(tidyverse)
library(sf)
library(tmap)
#help(package = "lconnect")

# options
options(scipen = 1e3)

# download
## Download
for(i in c(".dbf", ".prj", ".shp", ".shx")){
    
    # Polígonos de cobertura da terra
    download.file(
        url = paste0("http://geo.fbds.org.br/SP/RIO_CLARO/USO/SP_3543907_USO", i),
        destfile = paste0("SP_3543907_USO", i), mode = "wb")
}

# landscape
landscape <- sf::st_bbox(c(xmin = 225000, ymin = 7515000, xmax = 230000, ymax = 7520000)) %>% 
    sf::st_as_sfc() %>% 
    sf::st_as_sf(crs = 31983)
landscape

# forest
forest <- sf::st_read("SP_3543907_USO.shp") %>% 
    dplyr::filter(CLASSE_USO == "formação florestal") %>% 
    dplyr::mutate(habitat = 1) %>% 
    dplyr::select(habitat)

tm_shape(forest) + 
    tm_fill(col = "forestgreen") +
    tm_shape(landscape) +
    tm_borders()

forest_landscape <- sf::st_intersection(forest, landscape)
forest_landscape

tm_shape(forest_landscape) + 
    tm_fill(col = "forestgreen") +
    tm_shape(landscape) +
    tm_borders()

# export
sf::st_write(forest_landscape, "forest.gpkg", delete_dsn = TRUE)

# load data
vec_path <- "forest.gpkg"
vec_path

# upload landscape
land <- lconnect::upload_land(vec_path, habitat = 1, max_dist = 200)
land
class(land)

# plot
plot(land, main = "Landscape clusters")

land1 <- lconnect::patch_imp(landscape = land, metric = "IIC")
land1
class(land1)

plot(land1, main="Patch prioritization (%)")


# metrics -----------------------------------------------------------------

# link
# https://www.r-bloggers.com/2019/03/lconnect-connectivity-metrics/

# descriptions
#' NC – Number of components (groups of interconnected patches) in the landscape 
#' (Urban and Keitt, 2001). Patches in the same component are considered to be 
#' accessible, while patches in different components are not. Highly connected 
#' landscapes have less components. Threshold dependent, i.e., maximum distance 
#' for two patches to be considered connected. Can be interpreted as the maximum
#' dispersal distance for a certain species.

#' LNK – Number of links connecting the patches. The landscape is interpreted as 
#' binary, which means that the habitat patches are either connected or not 
#' (Pascual-Hortal and Saura, 2006). Higher LNK implies higher connectivity.
#' Threshold dependent.

#' SLC – Area of the largest group of interconnected patches (Pascual- Hortal 
#' and Saura, 2006). Threshold dependent.

#' MSC – Mean area of interconnected patches (Pascual-Hortal and Saura, 2006). 
#' Threshold dependent.

#' CCP – Class coincidence probability. It is defined as the probability that two 
#' randomly chosen points within the habitat belong to the same component (or 
#' cluster). Ranges between 0 and 1 (Pascual-Hortal and Saura 2006). Higher CCP 
#' implies higher connectivity. Threshold dependent.

#' LCP – Landscape coincidence probability. It is defined as the probability that
#' two randomly chosen points in the landscape (whether in an habitat patch or 
#' not) belong to the same habitat component (or cluster). Ranges between 0 and
#' 1 (Pascual-Hortal and Saura 2006). Threshold dependent.

#' CPL – Characteristic path length. Mean of all the shortest paths between the
#' habitat patches (Minor and Urban, 2008). The shorter the CPL value the more 
#' connected the patches are. Threshold dependent.

#' ECS – Expected component (or cluster) size. Mean cluster size of the clusters 
#' weighted by area. (O’Brien et al., 2006 and Fall et al, 2007). This represents 
#' the size of the component in which a randomly located point in an habitat patch
#' would reside. Although it is informative regarding the area of the component, 
#' it does not provide any ecologically meaningful information regarding the 
#' total area of habitat. As an example: ECS increases with less isolated 
#' small components or patches, although the total habitat decreases 
#' (Laita et al. 2011). Threshold dependent.

#' AWF – Area-weighted Flux. Evaluates the flow, weighted by area, between all 
#' pairs of patches (Bunn et al. 2000 and Urban and Keitt 2001). The probability 
#' of dispersal between two patches, was computed using pij=exp(-k * dij), where 
#' k is a constant making pij (the dispersal probability between patches) 50% 
#' at half the dispersal distance defined by the user. Although k, as was 
#' implemented, is dependent on the dispersal distance, AWF is a probabilistic 
#' index and not directly dependent on the threshold.

#' IIC – Integral index of connectivity. Index developed specifically for 
#' landscapes by Pascual-Hortal and Saura (2006). It is based on habitat availability
#'  and on a binary connection model (as opposed to a probabilistic). It ranges 
#'  from 0 to 1 (higher values indicating more connectivity). Threshold dependent.0

lconnect::con_metric(land, metric = c("NC", "LNK", "SLC", "MSC", "CCP", 
                                      "LCP", "CPL", "ECS", "AWF", "IIC")) %>% 
    tibble::as_tibble() %>% 
    dplyr::bind_cols(tibble::tibble(metrics = c("NC", "LNK", "SLC", "MSC", 
                                                "CCP", "LCP", "CPL", "ECS", 
                                                "AWF", "IIC")), .) %>% 
    tinytable::tt(theme = "bootstrap") %>% 
    print("html")

# references --------------------------------------------------------------

#' Bunn, A. G., Urban, D. L., and Keitt, T. H. (2000). Landscape connectivity: 
#' a conservation application of graph theory. Journal of Environmental 
#' Management, 59(4): 265-278.

#' Fall, A., Fortin, M. J., Manseau, M., and O’ Brien, D. (2007). Spatial graphs:
#' principles and applications for habitat connectivity. Ecosystems, 10(3): 448-461.

#' Laita, A., Kotiaho, J.S., Monkkonen, M. (2011). Graph-theoretic connectivity 
#' measures: what do they tell us about connectivity? Landscape Ecology, 26: 951-967.
#
#' Minor, E. S., and Urban, D. L. (2008). A Graph-Theory Framework for Evaluating 
#' Landscape Connectivity and Conservation Planning. Conservation Biology, 22(2): 297-307.

#' O’Brien, D., Manseau, M., Fall, A., and Fortin, M. J. (2006). Testing the 
#' importance of spatial configuration of winter habitat for woodland caribou: 
#' an application of graph theory. Biological Conservation, 130(1): 70-83.

#' Pascual-Hortal, L., and Saura, S. (2006). Comparison and development of new 
#' graph-based landscape connectivity indices: towards the priorization of habitat 
#' patches and corridors for conservation. Landscape Ecology, 21(7): 959-967.

#' Urban, D., and Keitt, T. (2001). Landscape connectivity: a graph-theoretic 
#' perspective. Ecology, 82(5): 1205-1218.