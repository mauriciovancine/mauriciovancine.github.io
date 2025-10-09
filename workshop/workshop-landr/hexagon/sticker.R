
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)

imgurl <- magick::image_read("teaching/workshop-landscapemetrics/hexagon/img.png")

hexSticker::sticker(
  subplot = imgurl, 
  package = "landR", 
  p_x = 1, p_y = 1.5, 
  p_size = 15, 
  p_color = "gray30",
  s_x = 1, s_y = .7, 
  s_width = 1.2, s_height = 1.2,
  h_fill = "#dbe3e2",
  h_color = "#157769",
  filename = "teaching/workshop-landscapemetrics/featured-hex.png")

