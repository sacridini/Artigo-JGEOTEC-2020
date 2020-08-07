library(raster)
library(dplyr)

# Input -------------------------------------------------------------------
ndvi <- raster::raster("~/Documents/jgeotec2020/raster/ndvi_max_1985_2018.tif")
for_pnts <- raster::shapefile("~/Documents/jgeotec2020/vector/point_forest.shp")
past_pnts <- raster::shapefile("~/Documents/jgeotec2020/vector/point_pasture.shp")

# Update ID column (optional) ---------------------------------------------
for (i in 1:length(for_pnts)) {
  for_pnts[[1]][i] <- i 
  past_pnts[[1]][i] <- i 
}

# Extract Values ----------------------------------------------------------
for_pnts$values <- raster::extract(ndvi, for_pnts)
past_pnts$values <- raster::extract(ndvi, past_pnts)

# Convert to data.frame ---------------------------------------------------
for_pnts_df <- as.data.frame(for_pnts)
past_pnts_df <- as.data.frame(past_pnts)

# New Column (class) -> for ANOVA -----------------------------------------
for_pnts_df$class <- "for"
past_pnts_df$class <- "past"


# Create ANOVA data.frame -------------------------------------------------
pnts_df <- rbind(for_pnts_df, past_pnts_df)
pnts_df <- dplyr::select(pnts_df, class, values)

# ANOVA -------------------------------------------------------------------
# O teste ANOVA neste caso serve para ver se as amostras de floresta e pasto foram bem coletadas
# A resposta que esperamos é que o P valor aqui seja o menor possível, demonstrando diferença entre as duas classes
test <- aov(values ~ class, data = pnts_df)
summary(test)

# Threshold Calculation ---------------------------------------------------
for_min_value <- min(for_pnts_df$values)
message(for_min_value)


# Reclassify NDVI Raster --------------------------------------------------
ndvi_reclass <- ndvi
ndvi_reclass[ndvi_reclass < 0.83] <- NA
raster::writeRaster(ndvi_reclass, "~/Documents/jgeotec2020/raster/ndvi_reclass_gt830.tif", options = "COMPRESS=DEFLATE")

# Create and save an Binary Raster Version --------------------------------
ndvi_reclass_bin <- ndvi_reclass
ndvi_reclass_bin[ndvi_reclass_bin >= 0.83] <- 1
raster::writeRaster(ndvi_reclass_bin, "~/Documents/jgeotec2020/raster/ndvi_reclass_gt830_bin.tif", options = "COMPRESS=DEFLATE")

# Merge NDVI bin with Mapbiomas bin ---------------------------------------
for_mapbiomas <- raster::raster("~/Documents/jgeotec2020/raster/for_bin_sj.tif")
always_forest <- ndvi_reclass_bin * for_mapbiomas
raster::writeRaster(always_forest, "~/Documents/jgeotec2020/raster/always_forest_bin.tif", options = "COMPRESS=DEFLATE")
