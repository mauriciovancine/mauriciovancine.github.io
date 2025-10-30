
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("workshop/workshop-data-visr/hexagon/r_logo.svg")

hexSticker::sticker(
  subplot = imgurl, 
  package = "visR", 
  p_size = 25, 
  p_color = "gray30",
  s_x = .94, s_y = .75, 
  s_width = 1.1, s_height = 1.1,
  h_fill = "#dae3e2",
  h_color = "gray50") %>% 
  ggsave(filename = "workshop/workshop-data-visr/featured-hex.png", 
         width = 5, height = 5, units = "cm", dpi = 300)

