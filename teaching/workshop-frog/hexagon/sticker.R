
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("teaching/workshop-frog/hexagon/img.png")

sticker(imgurl, 
        package = "frog", 
        p_size = 25, 
        p_color = "gray30",
        s_x = .9, s_y = .7,
        s_width = 1.4, s_height = 1.4,
        h_fill = "#dbe3e2",
        h_color = "forestgreen",
        filename = "teaching/workshop-frog/featured-hex.png")

