
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read('content/project/ecologia-r/hexagon/img.png')

sticker(imgurl, 
        package = "Ecologia no R", 
        p_size = 20, 
        p_color = "#f3c800",
        s_x = 1, s_y = .7, s_width = 1.2, s_height = 1.2,
        h_fill = "white",
        h_color = "#205720",
        filename = "content/project/ecologia-r/featured-hex.png")

