library(tidyverse)
library(terra)

rc <- terra::rast("raster.tif")
rc

plot(rc)

# edge
rc_na <- terra::ifel(rc == 3, 1, NA) 
rc_na
plot(rc_na)

rc_matrix <- terra::ifel(rc != 3, 1, NA)
rc_matrix
plot(rc_matrix)

rc_matrix_dist <- terra::distance(rc_matrix) * rc_na
rc_matrix_dist
plot(rc_matrix_dist)

da_edge <- freq(rc_matrix_dist) %>% 
    tibble::as_tibble() %>% 
    dplyr::mutate(class = case_when(value > 0 & value <= 100 ~ "0-100",
                                    value > 100 & value <= 200 ~ "100-200",
                                    value > 200 & value <= 300 ~ "200-300",
                                    value > 300 & value <= 400 ~ "300-400",
                                    value > 400 & value <= 500 ~ "400-500",
                                    value > 500 & value <= 600 ~ "500-600",
                                    value > 600 & value <= 700 ~ "600-700",
                                    value > 700 & value <= 800 ~ "700-800",
                                    value > 800 & value <= 800 ~ "800-900",
                                    value > 900 & value <= 1000 ~ "900-1000",
                                    value > 1000 ~ ">1000")) %>% 
    dplyr::group_by(class) %>% 
    dplyr::summarise(count_sum = sum(count)) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(prop = count_sum/sum(count_sum),
                  cum_sum = cumsum(prop))
da_edge

ggplot(data = da_edge, aes(x = class, y = prop, fill = class, label = prop)) +
    geom_bar(stat = "identity") +
    geom_line(aes(y = cum_sum, group = 1), color = "#5d7a4e", size = 2) +
    geom_text(aes(label = round(prop, 2)), size = 10, nudge_y = .03) +
    scale_fill_manual(values = c("#c35235", "#d86e2f", "#ee9f37", "#f9c638", "#f7ea3e", "#8cc449", "#4fb453", "#24b963", "#159290", "#0d6080", "#283479")) +
    labs(x = "Distance to edge (m)", y = "Proportion of forest") +
    theme_classic(base_size = 25) +
    theme(legend.position = "none",
          axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1),
          axis.ticks = element_blank())


# area and number of fragments
rc_pid <- terra::patches(rc, zeroAsNA = TRUE, allowGaps = FALSE)
rc_pid
plot(rc_pid)

da_pid <- terra::freq(rc_pid) %>% 
    dplyr::mutate(area_ha = count*(res(rc)[1]^2)/1e4) %>% 
    dplyr::mutate(class = case_when(area_ha > 0 & area_ha <= 10 ~ "1-10",
                                    area_ha > 10 & area_ha <= 100 ~ "10-100",
                                    area_ha > 100 & area_ha <= 1000 ~ "100-1,000",
                                    area_ha > 1000 & area_ha <= 10000 ~ "1,000-10,000",
                                    area_ha > 10000 ~ ">10,000")) %>% 
    dplyr::mutate(class = forcats::fct_relevel(class, c("1-10", "10-100", "100-1,000", "1,000-10,000", ">10,000"))) %>% 
    dplyr::group_by(class) %>% 
    dplyr::summarise(np = n(),
                     area_sum = sum(area_ha)) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(cum_sum = cumsum(area_sum))
da_pid

ggplot(data = da_pid, aes(x = class, y = np/1e3)) +
    geom_bar(stat = "identity") +
    # geom_line(aes(y = cum_sum, group = 1), color = "#5d7a4e", size = 2) +
    labs(x = "Fragment area (ha)", y = "Number of fragments (1000s)") +
    theme_classic(base_size = 25) +
    theme(legend.position = "none",
          axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1),
          axis.ticks = element_blank())
