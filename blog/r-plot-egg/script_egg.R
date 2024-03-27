library(tidyverse)
library(RColorBrewer)
library(palmerpenguins)
library(ggdensity)
library(ggord)

tb <- penguins %>%
    dplyr::select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
    tidyr::drop_na()
tb

pca <- prcomp(tb[, -1], center = TRUE, scale. = TRUE)
pca

summary(pca)

scores <- pca$x
scores

loadings <- data.frame(variables = rownames(pca$rotation), pca$rotation)
loadings

biplot(pca)
ggord(pca, tb$species, cols = c('purple', 'orange', 'cyan4'))

ggplot(data = scores, aes(x = PC1, y = PC2)) +
    geom_hdr(aes(fill = after_stat(probs)),
             probs = c(.99, .95, .75, .5, .25, .01),
             alpha = 1, show.legend = FALSE) +
    geom_hdr_lines(color = "gray", probs = c(.95, .75, .5, .25, .01), alpha = .5, show.legend = FALSE) +
    geom_hdr_lines(color = "black", probs = .99, alpha = 1, show.legend = FALSE) +
    geom_point(pch = 20, size = 2, alpha = .7, aes(color = tb$species)) +
    geom_segment(data = loadings, aes(x = 0, y = 0, xend = PC1, yend = PC2 * 2),
                 arrow = arrow(length = unit(1/2, "picas")), color = "black", lwd = .8) +
    geom_hline(yintercept = 0, linetype = 2, color = "gray") +
    geom_vline(xintercept = 0, linetype = 2, color = "gray") +
    stat_ellipse( aes(color = tb$species)) +
    scale_color_manual(values = c('purple', 'orange', 'cyan4')) +
    scale_fill_manual(values = brewer.pal(6, "YlOrRd")) +
    annotate("text", x = (loadings$PC1 * 3), y = (loadings$PC2 * 2), 
             label = loadings$variables, size = 5) +
    labs(x = paste0("PC1 (", "69%)"),
         y = paste0("PC2 (", "20%)"), 
         color = "Species") +
    xlim(-4, 5) +
    ylim(-3.5, 3.5) +
    theme_bw(base_size = 20) +
    theme(legend.position = c(.85, .85))
