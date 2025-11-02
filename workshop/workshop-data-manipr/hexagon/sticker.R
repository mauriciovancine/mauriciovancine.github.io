
# remotes::install_github("GuangchuangYu/hexSticker")

library(tidyverse)
library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("workshop/workshop-data-manipr/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "manipR", 
  p_size = 20, 
  p_color = "gray30",
  s_x = .94, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dae3e2",
  h_color = "gray50") +
  theme(plot.margin = margin(5, 5, 5, 5)) +
  ggsave(filename = "workshop/workshop-data-manipr/featured-hex.png", 
         width = 5, height = 5, units = "cm", dpi = 300)

