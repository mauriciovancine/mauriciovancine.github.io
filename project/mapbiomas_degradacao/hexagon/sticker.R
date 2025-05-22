
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(png)

imgurl <- magick::image_read('project/mapbiomas_degradacao/hexagon/logo.png')

hexSticker::sticker(
  imgurl, 
  package = "MapBiomas", 
  p_size = 20, 
  p_color = "#78b897",
  s_x = 1, s_y = .75, s_width = .9, s_height = .9,
  h_fill = "#ffffff",
  #h_fill = "white",
  h_color = "#93632d",
  filename = "project/mapbiomas_degradacao/featured-hex.png")

