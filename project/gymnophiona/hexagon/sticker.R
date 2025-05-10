
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)
library(magrittr)

img <- magick::image_read("content/project/gymnophionas/hexagon/img.png")
img_tr <- magick::image_transparent(img, "white")
magick::image_write(img_tr, "content/project/gymnophionas/hexagon/img_tr.png")

img <- magick::image_read("content/project/gymnophionas/hexagon/img_tr.png")

sticker(img, 
        package = "Gymnophionas", 
        p_size = 15, 
        p_color = "#55308d",
        s_x = .9, s_y = .7, 
        s_width = 1.1, s_height = 1.1,
        h_fill = "white",
        h_color = "#55308d",
        filename = "content/project/gymnophionas/featured-hex.png")

