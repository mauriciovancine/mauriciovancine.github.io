
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("content/teaching/course-geor/hexagon/r_logo_spatial.png")

sticker(imgurl, 
        package = "GeoR", 
        p_size = 25, 
        p_color = "gray30",
        s_x = .94, s_y = .75, 
        s_width = 1.1, s_height = 1.1,
        h_fill = "#dbe3e2",
        h_color = "#008080",
        filename = "content/teaching/course-geor/featured-hex.png")

