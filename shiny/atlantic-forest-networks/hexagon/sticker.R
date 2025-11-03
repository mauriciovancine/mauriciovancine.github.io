
# remotes::install_github("GuangchuangYu/hexSticker")

library(tidyverse)
library(hexSticker)
library(magick)

imgurl <- magick::image_read('shiny/atlantic-forest-networks/hexagon/img.png')
imgurl <- magick::image_transparent(imgurl, "white")

hexSticker::sticker(
  imgurl, 
  package = "afnetworks", 
  p_size = 20, p_color = "#4f7476",
  s_x = 1, s_y = .68, s_width = 1.2, s_height = 1.2,
  h_fill = "white",
  h_color = "forestgreen") +
  theme(plot.margin = margin(5, 5, 5, 5)) +
  ggsave(filename = "shiny/atlantic-forest-networks/featured-hex.png", 
         width = 5, height = 5, units = "cm", dpi = 300)
