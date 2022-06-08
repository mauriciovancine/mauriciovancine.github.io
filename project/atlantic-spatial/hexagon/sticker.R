
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)
library(magrittr)

# img <- magick::image_read("content/project/atlantic-spatial/hexagon/img.png")
# img_tr <- magick::image_transparent(img, "white")
# magick::image_write(img_tr, "content/project/atlantic-spatial/hexagon/img_tr.png")

img <- magick::image_read("content/project/atlantic-spatial/hexagon/img_tr.png")

sticker(img, 
        package = "Atlantic Spatial", 
        p_size = 15, 
        p_color = "black",
        s_x = 1.25, s_y = .7, 
        s_width = 1.5, s_height = 1.5,
        h_fill = "white",
        h_color = "#007158",
        filename = "content/project/atlantic-spatial/featured-hex.png")

