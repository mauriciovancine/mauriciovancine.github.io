
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("teaching/workshop-prog-r/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "progR", 
  p_size = 25, 
  p_color = "gray30",
  s_x = .94, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dae3e2",
  h_color = "gray50",
  filename = "teaching/workshop-prog-r/featured-hex.png")

