# packages
library(scholar)
library(tidyverse)

# id scholar
id_scholar <- scholar::get_scholar_id(last_name = "Vancine", first_name = "Maurício")
id_scholar

# perfil
perfil <- scholar::get_profile(id_scholar)
perfil
names(perfil)

# publications
pub <- scholar::get_publications(id_scholar)
pub

n_pub <- pub %>%
  dplyr::count(year, name = "publications")
n_pub

pub_journal <- pub %>%
  dplyr::count(journal, sort = TRUE, name = "publications") %>%
  dplyr::filter(journal != "Recife: Nupeea; Bauru, SP: Canal")
pub_journal

pub_journalrank <- scholar::get_journalrank(pub$journal)
pub_journalrank

pub_num_articles <- scholar::get_num_articles(id_scholar)
pub_num_articles

pub_formated <- scholar::format_publications(id_scholar)
pub_formated

pub_distinct_journals <- scholar::get_num_distinct_journals(id_scholar)
pub_distinct_journals

pub_top_journals <- scholar::get_num_top_journals(id_scholar)
pub_top_journals

pub_oldest_article <- scholar::get_oldest_article(id_scholar)
pub_oldest_article

# citations
n_cites <- scholar::get_citation_history(id_scholar)
n_cites

# predict_h_index
scholar::predict_h_index(id)

# figures
ggplot(n_pub, aes(x = forcats::as_factor(year), y = publications, group = 1)) +
  geom_bar(stat = "identity") +
  geom_point(size = 15, alpha = .3) +
  geom_line(alpha = .5) +
  geom_text(aes(label = publications), size = 6, vjust = .5, color = "white") +
  labs(x = "", y = "Publicações",
       title = "Número de publicações no Google Scholar",
       subtitle = paste0(perfil$name, " (", min(n_cites$year), "-", max(n_cites$year), ")")) +
  theme_bw(base_size = 20)
ggsave("~/Downloads/publicacoes.png", width = 25, height = 20, units = "cm", dpi = 300)

ggplot(pub_journal, aes(x = forcats::as_factor(journal), y = publications)) +
  geom_bar(stat = "identity") +
  labs(x = "", y = "Publicações",
       title = "Número de publicações por revista",
       subtitle = paste0(perfil$name, " (", min(n_cites$year), "-", max(n_cites$year), ")")) +
  theme_bw(base_size = 20) +
  theme(axis.text.x = element_text(size = 15, angle = 90, hjust = 1, vjust = .4))
ggsave("~/Downloads/publicacoes.png", width = 25, height = 20, units = "cm", dpi = 300)

ggplot(n_cites, aes(x = forcats::as_factor(year), y = cites, group = 1)) +
    geom_bar(stat = "identity") +
    geom_point(size = 15, alpha = .3) +
    geom_line(alpha = .5) +
    geom_text(aes(label = cites), size = 6, vjust = .5, color = "white") +
    labs(x = "", y = "Citações",
         title = "Número de citações no Google Scholar",
         subtitle = paste0(perfil$name, " (", min(n_cites$year), "-", max(n_cites$year), ")")) +
    annotate(geom = "text", x = 1.3, y = max(n_cites$cites)-max(n_cites$cites)*.1, size = 6,
             label = paste0("Citações = ", perfil$total_cites,
                            "\nÍndice H = ", perfil$h_index,
                            "\nÍndice i10 = ", perfil$i10_index)) +
    theme_bw(base_size = 20)
ggsave("~/Downloads/citacoes.png", width = 25, height = 20, units = "cm", dpi = 300)

# coautores
coautores <- scholar::get_coauthors(id = id_scholar, n_coauthors = 10) %>% 
    dplyr::filter(!coauthors %in% c("About Scholar", "Search Help"))
coautores

scholar::plot_coauthors(coautores, size_labels = 5)
ggsave("~/Downloads/coautores.png", width = 25, height = 20, units = "cm", dpi = 300)

# end ---------------------------------------------------------------------