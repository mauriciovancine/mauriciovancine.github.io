
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("teaching/workshop-sheet/hexagon/img.png")

sticker(imgurl, 
        package = "calc", 
        p_size = 25, 
        p_color = "gray30",
        s_x = 1, s_y = .7,
        s_width = .8, s_height = .8,
        h_fill = "#dbe3e2",
        h_color = "#2bd757",
        filename = "teaching/workshop-sheet/featured-hex.png")

