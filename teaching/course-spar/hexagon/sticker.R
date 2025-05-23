
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("teaching/course-spar/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "spaR", 
  p_size = 25, 
  p_x = 1, p_y = 1.5, 
  p_color = "gray30",
  s_x = .94, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dbe3e2",
  h_color = "#007166",
  filename = "teaching/course-spar/featured-hex.png")
