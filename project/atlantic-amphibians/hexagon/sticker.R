
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read('content/project/atlantic-amphibians/hexagon/img2.png')

sticker(imgurl, 
        package = "Atlantic Amphibians", 
        p_size = 13, 
        p_color = "forestgreen",
        s_x = .9, s_y = .75, s_width = 1.5, s_height = 1.5,
        h_fill = "white",
        h_color = "forestgreen",
        filename = "content/project/atlantic-amphibians/featured-hex.png")

