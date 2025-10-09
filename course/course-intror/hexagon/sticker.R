
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("teaching/course-intror/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "introR", 
  p_size = 25, 
  p_x = 1, p_y = 1.5, 
  p_color = "gray30",
  s_x = .95, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dbe3e2",
  h_color = "#0066af",
  filename = "teaching/course-intror/featured-hex.png")
