
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read_svg("teaching/workshop-spadiv-r/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "spadivR", 
  p_size = 25, 
  p_color = "gray30",
  s_x = .94, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dae3e2",
  h_color = "#3a5813",
  filename = "teaching/workshop-spadiv-r/featured-hex.png")

