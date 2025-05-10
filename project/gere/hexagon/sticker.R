
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read('/home/mude/data/github/mauriciovancine/apero/content/project/gere/hexagon/img.png')

sticker(imgurl, 
        package = "GERE", 
        p_size = 30, 
        p_color = "black",
        s_x = 1, s_y = .7, s_width = 1.7, s_height = 1.7,
        h_fill = "#fb1aa2",
        h_color = "black",
        filename = "content/project/gere/featured-hex.png",
        url = "")

