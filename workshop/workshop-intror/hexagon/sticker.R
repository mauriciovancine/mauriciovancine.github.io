
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read_svg("content/teaching/intror/hexagon/r_logo.svg")

sticker(imgurl, 
        package = "IntroR", 
        p_size = 25, 
        p_color = "gray30",
        s_x = .94, s_y = .75, 
        s_width = 1.1, s_height = 1.1,
        h_fill = "#dbe3e2",
        h_color = "#0066af",
        filename = "content/teaching/intror/featured-hex.png")

