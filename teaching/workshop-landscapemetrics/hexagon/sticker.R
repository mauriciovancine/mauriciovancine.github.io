
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("content/teaching/workshop-landscapemetrics/hexagon/img.png")

sticker(imgurl, 
        package = "landscapemetrics", 
        p_size = 15, 
        p_color = "gray30",
        s_x = 1, s_y = .7, 
        s_width = 1.1, s_height = 1.1,
        h_fill = "#dbe3e2",
        h_color = "#2e8b7a",
        filename = "content/teaching/workshop-landscapemetrics/featured.png")

