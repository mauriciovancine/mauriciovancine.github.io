
# remotes::install_github("GuangchuangYu/hexSticker")

library(hexSticker)
library(magick)

imgurl <- magick::image_read('shiny/atlantic-forest-networks/hexagon/img.png')
imgurl <- magick::image_transparent(imgurl, "white")

hexSticker::sticker(
  imgurl, 
  package = "afnetworks", 
  p_size = 50, p_color = "#4f7476",
  s_x = .9, s_y = .75, s_width = 1.5, s_height = 1.5,
  h_fill = "white",
  h_color = "forestgreen",
  filename = "shiny/atlantic-forest-networks/featured-hex.png") +
  theme(
    plot.margin = unit(c(1, 1, 1, 1), "cm") # topo, direita, baixo, esquerda
  )

ggsave(filename = "shiny/atlantic-forest-networks/featured-hex.png",
       width = 20, height = 20, units = "cm", dpi = 300)
