# install.packages("OpenLand")

# Loading the package
library(OpenLand)

# load
load("01_data/SaoLourencoBasin.rda")

# The SaoLourencoBasin dataset
SaoLourencoBasin
plot(SaoLourencoBasin)

SaoLourencoBasin_aggr <- raster::aggregate(SaoLourencoBasin, 3)
SaoLourencoBasin_aggr

plot(SaoLourencoBasin_aggr)

# Extracting the data from raster time series
SL_2002_2014 <- OpenLand::contingencyTable(input_raster = SaoLourencoBasin_aggr,
                                           pixelresolution = 30*3)
SL_2002_2014


## editing the category name
SL_2002_2014$tb_legend$categoryName <- factor(c("Ap", "FF", "SA", "SG", "aa", "SF",
                                                "Agua", "Iu", "Ac", "R", "Im"),
                                              levels = c("FF", "SF", "SA", "SG", "aa", "Ap",
                                                         "Ac", "Im", "Iu", "Agua", "R"))

## add the color by the same order of the legend,
## it can be the color name (eg. "black") or the HEX value (eg. #000000)
SL_2002_2014$tb_legend$color <- c("#FFE4B5", "#228B22", "#00FF00", "#CAFF70",
                                           "#EE6363", "#00CD00", "#436EEE", "#FFAEB9",
                                           "#FFA54F", "#68228B", "#636363")

## now we have
SL_2002_2014$tb_legend

testSL <- intensityAnalysis(dataset = SL_2002_2014,
                            category_n = "Ap", category_m = "SG")

# it returns a list with 6 objects
names(testSL)

testSL


# graphics ----------------------------------------------------------------

# Interval Level
plot(testSL$interval_lvl,
     labels = c(leftlabel = "Interval Change Area (%)",
                rightlabel = "Annual Change Area (%)"),
     marginplot = c(-8, 0), labs = c("Changes", "Uniform Rate"),
     leg_curv = c(x = 2/10, y = 3/10))

# Category Level
# Gain Area
plot(testSL$category_lvlGain,
     labels = c(leftlabel = bquote("Gain Area (" ~ km^2 ~ ")"),
                rightlabel = "Intensity Gain (%)"),
     marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"),
     leg_curv = c(x = 5/10, y = 5/10))


# Loss Area
plot(testSL$category_lvlLoss,
     labels = c(leftlabel = bquote("Loss Area (" ~ km^2 ~ ")"),
                rightlabel = "Loss Intensity (%)"),
     marginplot = c(.3, .3), labs = c("Categories", "Uniform Rate"),
     leg_curv = c(x = 5/10, y = 5/10))


netgrossplot(dataset = SL_2002_2014$lulc_Multistep,
             legendtable = SL_2002_2014$tb_legend,
             xlab = "LUC Category",
             ylab = bquote("Area (" ~ km^2 ~ ")"),
             changesLabel = c(GC = "Gross changes", NG = "Net Gain", NL = "Net Loss"),
             color = c(GC = "gray70", NG = "#006400", NL = "#EE2C2C")
)


chordDiagramLand(dataset = SL_2002_2014$lulc_Onestep,
                 legendtable = SL_2002_2014$tb_legend)


sankeyLand(dataset = SL_2002_2014$lulc_Multistep,
           legendtable = SL_2002_2014$tb_legend)

sankeyLand(dataset = SL_2002_2014$lulc_Onestep,
           legendtable = SL_2002_2014$tb_legend)


barplotLand(dataset = SL_2002_2014$lulc_Multistep,
            legendtable = SL_2002_2014$tb_legend,
            xlab = "Year",
            ylab = bquote("Area (" ~ km^2~ ")"),
            area_km2 = TRUE)
