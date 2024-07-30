# packages
# remotes::install_github("jamiemkass/ENMeval")

library(tidyverse)
library(lubridate)
library(ggsci)
library(sf)
library(terra)
library(geobr)
library(geodata)
library(spocc)
library(ENMeval)
library(rJava)
library(maxnet)
library(dismo)
library(tmap)

# maxent
download.file(url = "https://biodiversityinformatics.amnh.org/open_source/maxent/maxent.php?op=download",
              destfile = paste0(system.file("java", package = "dismo"), "/maxent.zip"), mode = "wb")

unzip(zipfile = paste0(system.file("java", package = "dismo"), "/maxent.zip"),
      exdir = system.file("java", package = "dismo"), junkpaths = TRUE)

dir(system.file("java", package = "dismo"))

system(paste0("java -jar ", system.file("java", package = "dismo"), "/maxent.jar"))

# occ
occ <- spocc::occ(query = "Boana faber", from = "gbif", has_coords = TRUE, limit = 80) |> 
    spocc::occ2df()
occ

occ_clean <- occ |> 
    dplyr::mutate(year = lubridate::year(date)) |> 
    dplyr::filter(year > 1970) |> 
    dplyr::distinct(longitude, latitude)
occ_clean

occ_v <- sf::st_as_sf(occ_clean, coords = c("longitude", "latitude"), crs = 4326)
occ_v

occ_v_edit <- mapedit::editFeatures(occ_v)
occ_v_edit

tm_shape(occ_v_edit) +
    tm_dots()

occ_v_edit_coords <- sf::st_coordinates(occ_v_edit)
occ_v_edit_coords

# limit
co <- geodata::gadm(level = 0, country = c("Brazil", "Argentina", "Paraguay"), 
                    path = "content/blog/sdm-enmeval/data") |> 
    sf::st_as_sf() |> 
    sf::st_union()
co

li <- occ_v_edit |> 
    terra::vect() |> 
    terra::buffer(3e5) |> 
    sf::st_as_sf() |> 
    sf::st_union() |> 
    sf::st_intersection(co) |> 
    sf::st_make_valid() |> 
    nngeo::st_remove_holes() |> 
    sf::st_as_sf()
li

tm_shape(li) +
    tm_polygons() +
    tm_shape(occ_v_edit) +
    tm_dots()

# covar
covar_pres <- geodata::worldclim_global(var = "bio", 
                                        res = 10, 
                                        path = "content/blog/sdm-enmeval/data")
names(covar_pres) <- c(paste0("bio0", 1:9), paste0("bio", 10:19))
covar_pres

covar_fut <- geodata::cmip6_world(model = "MIROC6", 
                                  ssp = "585", 
                                  time = "2061-2080", 
                                  var = "bio", 
                                  res = 10, 
                                  path = "content/blog/sdm-enmeval/data")
covar_fut

covar_pres_li <- covar_pres |> 
    terra::crop(li) |> 
    terra::mask(li)
covar_pres_li

covar_fut_li <- covar_fut |> 
    terra::crop(li) |> 
    terra::mask(li)
covar_fut_li

map_covar_pres <- tm_shape(covar_pres_li[[1]]) +
    tm_raster(pal = "-RdBu", breaks = seq(12, 28, 2)) +
    tm_shape(li) +
    tm_borders()

map_covar_fut <- tm_shape(covar_fut_li[[1]]) +
    tm_raster(pal = "-RdBu", breaks = seq(12, 28, 2)) +
    tm_shape(li) +
    tm_borders()

tmap::tmap_arrange(map_covar_pres, map_covar_fut)


# oppc
occ_v_edit_coords_oppc <- occ_v_edit_coords |>
    tibble::as_tibble() |> 
    dplyr::mutate(oppc = terra::extract(covar_pres_li[[1]], occ_v_edit_coords, cells = TRUE)[, 2]) |> 
    dplyr::distinct(oppc, .keep_all = TRUE) |> 
    dplyr::select(-oppc)
occ_v_edit_coords_oppc

# sdm
tune_args <- list(fc = c("L", "LQ", "H", "LQH", "LQHP", "LQHPT"), rm = seq(.5, 4, .5))
tune_args

eval_model <- ENMeval::ENMevaluate(occs = occ_v_edit_coords_oppc, 
                                   envs = covar_pres_li,
                                   tune.args = tune_args, 
                                   algorithm = "maxent.jar", 
                                   partitions = "randomkfold",
                                   partition.settings = list(kfolds = 10),
                                   n.bg = 1e5,
                                   parallel = TRUE, 
                                   numCores = 8)
eval_model

eval_resul <- eval_model@results
eval_resul

best_model_aic <- eval_resul |> 
    dplyr::filter(delta.AICc == 0)
best_model_aic

ggplot(eval_resul, aes(x = rm, y = delta.AICc, color = fc, group = fc)) +
    geom_line() +
    geom_point(color = "black", shape = 1) +
    geom_point(data = best_model_aic, aes(x = rm, y = delta.AICc), color = "red", size = 5) +
    geom_hline(yintercept = 2, lty = 2) +
    scale_color_lancet() +
    coord_cartesian(ylim = c(0, 200)) +
    labs(x = "Regularization multiplier", y = "Delta AICc", color = "Feature classes") +
    theme_bw(base_size = 15) +
    theme(legend.position = c(.85, .75), 
          legend.box.background = element_rect(colour = "black"))

ggplot(eval_resul, aes(x = rm, y = or.mtp.avg, color = fc, group = fc)) +
    geom_line() +
    geom_point(color = "black", shape = 1) +
    geom_point(data = best_model_aic, aes(x = rm, y = or.mtp.avg), color = "red", size = 5) +
    scale_color_lancet() +
    labs(x = "Regularization multiplier", y = "Average validation omission rates", color = "Feature classes") +
    theme_bw(base_size = 15) +
    theme(legend.position = c(.85, .75), 
          legend.box.background = element_rect(colour = "black"))

ggplot(eval_resul, aes(x = rm, y = auc.val.avg, color = fc, group = fc)) +
    geom_line() +
    geom_point(color = "black", shape = 1) +
    geom_point(data = best_model_aic, aes(x = rm, y = auc.val.avg), color = "red", size = 5) +
    geom_hline(yintercept = .75, lty = 2) +
    scale_color_lancet() +
    ylim(min(eval_resul$auc.val.avg) - .15, max(eval_resul$auc.val.avg) + .1) +
    labs(x = "Regularization multiplier", y = "Average validation AUC", color = "Feature classes") +
    theme_bw(base_size = 15) +
    theme(legend.position = c(.15, .25), 
          legend.box.background = element_rect(colour = "black"))


eval_model_best_aic <- eval.models(eval_model)[[best_model_aic$tune.args]]

model_best_aic <- eval_model@predictions[[best_model_aic$tune.args]]

varimp_best_model_aic <- dplyr::arrange(eval_model@variable.importance[[best_model_aic$tune.args]], -percent.contribution)

dismo::response(eval_model_best_aic, var = varimp_best_model_aic[1:6, 1], 
                cex.lab = 1.5, cex.axis = 1.2, bty = "l", main = main)

ggplot(varimp_best_model_aic, aes(x = percent.contribution, y = reorder(variable, percent.contribution))) +
    geom_bar(stat = "identity", fill = "gray") +
    scale_x_continuous(labels = scales::percent_format(scale = 1)) +
    labs(x = "Percent contribution", y = "") +
    theme_bw(base_size = 15) 

# Null models -------------------------------------------------------------

# fit
mod_null <- ENMnulls(eval_model, no.iter = 100, parallel = TRUE, numCores = 8,
                     mod.settings = list(fc = as.character(best_model_aic$fc), 
                                         rm = as.numeric(best_model_aic$rm)))
mod_null

# summary
null.emp.results(mod_null)

# histogram
evalplot.nulls(mod_null, stats = c("or.10p", "auc.val"), plot.type = "histogram")

# violin plot
evalplot.nulls(mod_null, stats = c("or.10p", "auc.val"), plot.type = "violin")


# threshold ---------------------------------------------------------------

# extract model estimated suitability for occurrence localities
sui_occ <- raster::extract(model_best_aic, eval_model@occs[, 1:2])
sui_occ

# extract model estimated suitability for background
sui_bg <- raster::extract(model_best_aic, eval_model@bg[, 1:2])
sui_bg

# evaluate predictive ability of model
ev <- evaluate(sui_occ, sui_bg)
ev

#detect possible thresholds 
thr <- threshold(ev)
thr

# plot using "equal sensitivity and specificity" criteria
model_best_aic_thr <- model_best_aic > thr$sensitivity

tm_shape(model_best_aic_thr) +
    tm_raster(pal = c("gray", "blue"), legend.show = FALSE) +
    tm_shape(sf::st_as_sf(occ_v_edit_coords_oppc, coords = c("X", "Y"), crs = 4326)) +
    tm_dots(col = "red")

# future prediction --------------------------------------------------------------

# future
model_best_aic_pred_fut <- enm.maxent.jar@predict(eval_model@models[[best_model_aic$tune.args]], 
                                                  covar_fut_li, other.settings = list(pred.type ="cloglog"))
model_best_aic_pred_fut

plot(terra::rast(model_best_aic))
plot(model_best_aic_pred_fut)

plot(terra::rast(model_best_aic) > thr$sensitivity)
plot(model_best_aic_pred_fut > thr$sensitivity)

# end ---------------------------------------------------------------------



