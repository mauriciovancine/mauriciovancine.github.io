
# grainscape
# https://www.alexchubaty.com/grainscape/index.html

# packages
library(tidyverse)
library(raster)
library(grainscape)
library(knitr)

# Modelling with grainscape -----------------------------------------------

# Model 1: The minimum planar graph ----

## Step 1: Preparing the resistance surface ----
patchy <- raster(system.file("extdata/patchy.asc", package = "grainscape"))
patchy
plot(patchy)

## Create an is-becomes matrix for reclassification
isBecomes <- cbind(c(1, 2, 3, 4, 5), c(1, 10, 8, 3, 6))
patchyCost <- reclassify(patchy, rcl = isBecomes)
patchyCost
plot(patchyCost)

## Plot this raster using ggplot2 functionality
## and the default grainscape theme
ggplot() +
  geom_raster(data = ggGS(patchyCost),
              aes(x = x, y = y, fill = value)) +
  scale_fill_distiller(palette = "Paired", guide = "legend") +
  guides(fill = guide_legend(title = "Resistance")) +
  theme_void() +
  theme(legend.position = "right")

## Step 2: Extracting the MPG ----
patchyMPG <- MPG(patchyCost, patch = (patchyCost == 1))
patchyMPG

## Step 3: Quick visualization of the MPG ----
plot(patchyMPG, quick = "mpgPlot")
plot(patchyMPG@lcpLinkId)
plot(patchyMPG@mpg)
plot(patchyMPG@voronoi)
plot(patchyMPG@lcpPerimWeight)
plot(patchyMPG@lcpLinkId)
plot(patchyMPG@mpgPlot)

## Step 4: Reporting on the MPG ----
# Extract tabular node information using the graphdf() function
nodeTable <- graphdf(patchyMPG)[[1]]$v
nodeTable

## Render table using the kable function,
## retaining the first three rows
knitr::kable(nodeTable[1:3, ], digits = 0, row.names = FALSE)

## Extract tabular link information using the graphdf() function
linkTable <- graphdf(patchyMPG)[[1]]$e
linkTable

## Render table using the kable function,
## retaining the first three rows
knitr::kable(linkTable[1:3, ], digits = 0, row.names = FALSE)

## Step 5: Thresholding the MPG ----
scalarAnalysis <- threshold(patchyMPG, nThresh = 5)
scalarAnalysis

## Use kable to render this as a table
kable(scalarAnalysis$summary,
      caption = paste("The number of components ('nComponents') in the",
                      "minimum planar graph at five automatically-selected",
                      "link thresholds ('maxLink)."))

scalarAnalysis <- threshold(patchyMPG, nThresh = 100)
scalarAnalysis

ggplot(scalarAnalysis$summary, aes(x = maxLink, y = nComponents)) +
  geom_line(colour = "forestgreen") +
  xlab("Link Threshold (resistance units)") +
  ylab("Number of components") +
  scale_x_continuous(breaks = seq(0, 1000, by = 100)) +
  scale_y_continuous(breaks = 1:20) +
  theme_light() + theme(axis.title = element_text())

## Step 6: Visualizing a thresholded graph ----
ggplot() +
  geom_raster(data = ggGS(patchyMPG, "patchId"),
              aes(x = x, y = y, fill = value > 0)) +
  scale_fill_manual(values = "grey") +
  geom_segment(data  = ggGS(patchyMPG, "links"),
               aes(x = x1, y = y1, xend = x2, yend = y2,
                   colour = lcpPerimWeight >= 250)) +
  scale_colour_manual(values = c("forestgreen", NA)) +
  geom_point(data = ggGS(patchyMPG, "nodes"), aes(x = x, y = y),
             colour = "darkgreen") +
  theme_void()

## Step 7: Next steps ----



# Model 2: Patch grains of connectivity -----------------------------------

## Step 1: Begin with a MPG -----

## Load the patchy raster distributed with grainscape
patchy <- raster(system.file("extdata/patchy.asc", package = "grainscape"))

## Create an is-becomes matrix for reclassification
isBecomes <- cbind(c(1, 2, 3, 4, 5), c(1, 10, 8, 3, 6))
patchyCost <- reclassify(patchy, rcl = isBecomes)

## Create the MPG model using cells = 1 as patches
patchyMPG <- MPG(patchyCost, patch = (patchyCost == 1))

## Step 2: Exploring the Voronoi tessellation ----

patchPlusVoronoi <- patchyMPG@voronoi
patchPlusVoronoi[patchyMPG@patchId] <- 0

ggplot() +
  geom_raster(data = ggGS(patchPlusVoronoi), aes(x = x , y = y, fill = value)) +
  theme_void()

## Step 3: Building GOC models ----
patchyGOC <- GOC(patchyMPG, nThresh = 10)
patchyGOC

## Step 4: Visualizing a GOC model ----
plot(grain(patchyGOC, whichThresh = 6), quick = "grainPlot", theme = FALSE) +
  theme_void()


# Landscape networks with 1D and 2D nodes ---------------------------------


