
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("content/teaching/course-sdmr/hexagon/img.png")

sticker(imgurl, 
        package = "sdmR", 
        p_size = 25, 
        p_color = "gray30",
        s_x = 1.05, s_y = .5, 
        s_width = 2.3, s_height = 2.3,
        h_fill = "#dbe3e2",
        h_color = "#800000",
        filename = "content/teaching/course-sdmr/featured-hex.png")

