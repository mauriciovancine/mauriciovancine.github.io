# packages
library(devtools)
# install_github("hcliedtke/AmphiNom", build_vignettes = FALSE)
library(AmphiNom)
library(knitr)

# get asw
asw_taxonomy <- AmphiNom::getTaxonomy()
asw_taxonomy

head(asw_taxonomy)
dim(asw_taxonomy)

# get synonyms
asw_synonyms_boana_faber <- AmphiNom::getSynonyms(asw_taxonomy, Species = "Boana faber")
asw_synonyms_boana_faber

rhinella_synonyms <- AmphiNom::getSynonyms(Genus = "Rhinella")
head(rhinella_synonyms, n = 15)

as.data.frame(table(rhinella_synonyms$species))

# summarise asw
bufonidae_stats <- AmphiNom::aswStats(asw_taxonomy = asw_taxonomy, verbose = TRUE, Family = "Bufonidae")
bufonidae_stats

pie(bufonidae_stats$Genera[order(bufonidae_stats$Genera, decreasing = T)], 
    cex = 0.5, 
    main = "No. of Species per Genus", 
    col = rainbow(length(bufonidae_stats$Genera),s = 0.5), 
    clockwise = TRUE, 
    border = NA)

# search species in asw
AmphiNom::aswSearch(query = "Boana faber", asw_taxonomy = asw_taxonomy)

# sync taxonomy
sync <- AmphiNom::aswSync(query = c("Boana faber", "Hyla faber"), 
                          asw = asw_synonyms, 
                          interactive = TRUE, 
                          return.no.matches = TRUE)

# synonym report
synonym_report <- AmphiNom::synonymReport(query_info = sync)
synonym_report

synonym_report_verbose <- AmphiNom::synonymReport(query_info = sync, verbose = TRUE)
synonym_report_verbose

synonym_report_verbose$names_not_found
synonym_report_verbose$ambiguities
synonym_report_verbose$duplicated
