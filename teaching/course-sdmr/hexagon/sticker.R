
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read("teaching/course-sdmr/hexagon/img.png")

hexSticker::sticker(
  subplot = imgurl, 
  package = "sdmR", 
  p_size = 25, 
  p_x = 1, p_y = 1.5, 
  p_color = "gray30",
  s_x = 1.05, s_y = .55, 
  s_width = 2.3, s_height = 2.3,
  h_fill = "#dbe3e2",
  h_color = "#800000",
  filename = "teaching/course-sdmr/featured-hex.png")

