tb <- tibble::tibble(x = c("temporal", "spatial"), y = c(10, 30))
tb

ggplot(data = tb, aes(x = x, y = y)) +
  geom_segment(aes(xend = x, yend = 0), linewidth = .8, color = "gray30") +
  geom_point(size = 7, color = "gray30") +
  geom_text(aes(label = as.character(round(y, 3))), size = 10, nudge_y = 3) +
  coord_flip() +
  theme_bw(base_size = 20)
ggsave(filename = "fig_s07.png", width = 30, height = 20, units = "cm", dpi = 300)
