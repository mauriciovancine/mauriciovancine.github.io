
# remotes::install_github("GuangchuangYu/hexSticker")

library(tidyverse)
library(hexSticker)
library(magick)

imgurl <- magick::image_read_svg("workshop/workshop-intror/hexagon/r_logo.svg")

sticker(imgurl, 
        package = "introR", 
        p_size = 25, 
        p_color = "gray30",
        s_x = .94, s_y = .75, 
        s_width = 1.1, s_height = 1.1,
        h_fill = "#dbe3e2",
        h_color = "#0066af") + 
  theme(plot.margin = margin(5, 5, 5, 5)) +
  ggsave(filename = "workshop/workshop-intror/featured-hex.png", 
         width = 5, height = 5, units = "cm", dpi = 300)

