
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("content/teaching/workshop-git/hexagon/img.png")

sticker(imgurl, 
        package = "git", 
        p_size = 25, 
        p_color = "gray30",
        s_x = 1, s_y = .65,
        s_width = 1, s_height = 1,
        h_fill = "#dbe3e2",
        h_color = "#ff453c",
        filename = "content/teaching/workshop-git/featured-hex.png")

