
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("teaching/course-geor/hexagon/r_logo_spatial.png")

hexSticker::sticker(
  subplot = imgurl, 
  package = "geoR", 
  p_size = 25, 
  p_x = 1, p_y = 1.5, 
  p_color = "gray30",
  s_x = .95, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dbe3e2",
  h_color = "#632678",
  filename = "teaching/course-geor/featured-hex.png")

