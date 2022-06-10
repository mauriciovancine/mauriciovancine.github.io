# library(terra)
# ra <- rast("content/project/atlantic-spatial/hexagon/input.tif")
# 
# png("content/project/atlantic-spatial/hexagon/img.png", he = 30, wi = 30, un = "cm", res = 300)
# plot(ra, col = c("gray", "forestgreen"), legend = FALSE, axes = FALSE)
# plot(as.polygons(ra, dissolve = TRUE), add = TRUE)
# dev.off()

# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)
library(magrittr)

img <- magick::image_read("content/project/atlantic-spatial/hexagon/img.png")
img_tr <- magick::image_transparent(img, "white")
magick::image_write(img_tr, "content/project/atlantic-spatial/hexagon/img_tr.png")

img <- magick::image_read("content/project/atlantic-spatial/hexagon/img_tr.png")

sticker(img, 
        package = "Atlantic Spatial", 
        p_size = 15, 
        p_color = "black",
        s_x = 1.25, s_y = .7, 
        s_width = 2.3, s_height = 2.3,
        h_fill = "white",
        h_color = "#007158",
        filename = "content/project/atlantic-spatial/featured-hex.png")

