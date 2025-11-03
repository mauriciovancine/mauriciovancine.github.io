
# remotes::install_github("GuangchuangYu/hexSticker")

library(tidyverse)
library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("course/course-reproductibility/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "reproducR", 
  p_size = 20, 
  p_x = 1, p_y = 1.45, 
  p_color = "gray30",
  s_x = .94, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dbe3e2",
  h_color = "#87b13f") +
  theme(plot.margin = margin(5, 5, 5, 5)) +
  ggsave(filename = "course/course-reproductibility/featured-hex.png", 
         width = 5, height = 5, units = "cm", dpi = 300)
