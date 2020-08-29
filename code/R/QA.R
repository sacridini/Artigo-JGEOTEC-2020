library(raster)

# Export raster for final analysis ----------------------------------------
r_class <- raster::raster("~/Documents/jgeotec2020/results/bhrsj_class_final.tif")
mapbiomas <- raster::raster("~/Documents/jgeotec2020/results/always_forest_bin.tif")

mapbiomas[mapbiomas == NA] <- 0

r_class_bin <- r_class
r_class_bin[r_class != 0] <- 5
r_class_bin[r_class == 0] <- 2
plot(r_class_bin)

rasterOptions(tolerance = 100)
r_comb <- mapbiomas + r_class_bin
plot(r_comb)

raster::writeRaster(r_comb, "~/Documents/jgeotec2020/results/r_comb.tif", options = "COMPRESS=DEFLATE", overwrite = TRUE)
raster::writeRaster(mapbiomas, "~/Documents/jgeotec2020/results/mapbiomas.tif", options = "COMPRESS=DEFLATE")


# Quality Check -----------------------------------------------------------
r <- raster::stack("~/Documents/jgeotec2020/raster/ts_final_ndvi.tif")

v_ext3 <- raster::shapefile("~/Documents/jgeotec2020/vector/r_ext_3_amostra_2k.shp")
ext3_extract <- raster::extract(r, v_ext3, df = TRUE)
ext3_extract$row_sd <- apply(ext3_extract[,-1], 1, sd)
anova_ext3 <- data.frame("values" = ext3_extract$row_sd, "class" = "ext3")

v_ext6 <- raster::shapefile("~/Documents/jgeotec2020/vector/r_ext_6_amostra_2k.shp")
ext6_extract <- raster::extract(r, v_ext6, df = TRUE)
ext6_extract$row_sd <- apply(ext6_extract[,-1], 1, sd)
anova_ext6 <- data.frame("values" = ext6_extract$row_sd, "class" = "ext6")

v_ext2 <- raster::shapefile("~/Documents/jgeotec2020/vector/r_ext_2_amostra_2k.shp")
ext2_extract <- raster::extract(r, v_ext2, df = TRUE)
ext2_extract$row_sd <- apply(ext2_extract[,-1], 1, sd)
anova_ext2 <- data.frame("values" = ext2_extract$row_sd, "class" = "ext2")

anova_all <- rbind(anova_ext3, anova_ext6, anova_ext2) # merge
anova_result <- aov(values ~ class, data = anova_all) # ANOVA
summary(anova_result)
TukeyHSD(anova_result) # Teste de Tukey
