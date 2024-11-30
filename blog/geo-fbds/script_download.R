download.file(url = "https://geo.fbds.org.br/TABELA%20CONSOLIDADA.xls",
              destfile = "TABELA_CONSOLIDADA.xls", mode = "wb")

fbds_data <- readxl::read_excel("TABELA_CONSOLIDADA.xls") %>%
  dplyr::slice(-c(1:4)) %>%
  dplyr::select(1:3) %>%
  dplyr::rename(code_muni = 1, name_muni = 2, abbrev_state = 3) %>%
  dplyr::filter(abbrev_state == "GO") %>%
  dplyr::mutate(name_muni = stringi::stri_trans_general(stringr::str_replace_all(name_muni, " ", "_"), "Latin-ASCII"))
fbds_data

for(i in 1:nrow(fbds_data)){

  for(j in c(".dbf", ".prj", ".shp", ".shx")){
    download.file(paste0("https://geo.fbds.org.br/", fbds_data[i, ]$abbrev_state, "/", fbds_data[i, ]$name_muni, "/USO/", fbds_data[i, ]$abbrev_state, "_", fbds_data[i, ]$code_muni, "_USO", j),
                  paste0(fbds_data[i, ]$abbrev_state, "_", fbds_data[i, ]$code_muni, "_USO", j), mode = "wb")
  }

  }
