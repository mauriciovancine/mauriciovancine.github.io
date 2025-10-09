
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("teaching/workshop-gee/hexagon/img.png")

sticker(imgurl, 
        package = "GEE", 
        p_size = 25, 
        p_color = "gray30",
        s_x = 1, s_y = .75,
        s_width = 1, s_height = 1,
        h_fill = "#dbe3e2",
        h_color = "#2c65d7",
        filename = "teaching/workshop-gee/featured-hex.png")

