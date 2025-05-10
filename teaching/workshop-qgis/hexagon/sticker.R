
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

img <- magick::image_read("content/teaching/workshop-git-github-rstudio/hexagon/img.png")
img_tr <- magick::image_transparent(img, "white")
magick::image_write(img_tr, "content/teaching/workshop-git-github-rstudio/hexagon/img_tr.png")

imgurl <- magick::image_read("content/teaching/workshop-qgis/hexagon/img.png")

sticker(imgurl, 
        package = "QGIS", 
        p_size = 25, 
        p_color = "gray30",
        s_x = 1, s_y = .75, 
        s_width = .9, s_height = .9,
        h_fill = "#dbe3e2",
        h_color = "#589632",
        filename = "content/teaching/workshop-qgis/featured-hex.png")

