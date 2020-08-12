rm(list = ls()); gc()
library(raster)
library(data.table)

forest_samples <- data.table::fread("~/Documents/jgeotec2020/tables/forest_samples.csv") # Load CSV Earth Engine forest sample output
forest_samples$CID <- rep(1:length(forest_samples$`system:index`)) # Add CID field
AForest_samples <- raster::shapefile("~/Documents/jgeotec2020/vector/Aforest_samples.shp") # Load forest samples shapefile
AForest_samples$CID <- rep(1:length(AForest_samples$CID)) # Change CID field of original shapefile

pasture_samples <- data.table::fread("~/Documents/jgeotec2020/tables/pasture_samples.csv") # Load CSV Earth Engine forest sample output
pasture_samples$CID <- rep(1:length(pasture_samples$`system:index`)) # Add CID field
Apasture_samples <- raster::shapefile("~/Documents/jgeotec2020/vector/Apasture_samples.shp") # Load pasture samples shapefile
Apasture_samples$CID <- rep(1:length(pasture_samples$CID))# Change CID field of original shapefile
  
forest_samples_shp_merged <- merge(AForest_samples, forest_samples, by='CID') # Merge! 
pasture_samples_shp_merged <- merge(Apasture_samples, pasture_samples, by='CID') # Merge!

pasture_samples_shp_merged$CID <- rep(length(AForest_samples$CID):(length(AForest_samples$CID) + length(Apasture_samples$CID)-1)) # Change CID entries for rbind aggregation
output_samples_shp <- rbind(forest_samples_shp_merged, pasture_samples_shp_merged)
output_samples_shp$class <- NA
output_samples_shp$class[1:length(AForest_samples$CID)] <- "for" # set "for" name to class column
output_samples_shp$class[length(AForest_samples$CID):(length(AForest_samples$CID) + length(Apasture_samples$CID))] <- "past" # set "past" name to class column

data.table::fwrite(output_samples_shp@data, "~/Documents/jgeotec2020/tables/output_samples.csv") # Export output as csv for MLR
raster::shapefile(output_samples_shp, "~/Documents/jgeotec2020/vector/output_samples.shp") # Export output as shapefile



# Just Tables -------------------------------------------------------------
for_tb <- read.csv("~/Documents/jgeotec2020/tables/testes_bhrsj_257_pnts/samples_forest_bhrsj_blue.csv") # Load for samples
ltr_tb <- read.csv("~/Documents/jgeotec2020/tables/testes_bhrsj_257_pnts/ltr_bhrsj_blue.csv") # Load ltr samples


cid_len <- length(for_tb$system.index)
cid_len_double <- cid_len * 2
for_tb$CID <- rep(1:cid_len)
ltr_tb$CID <- rep((cid_len + 1):cid_len_double)

# create class column
for_tb$class <- "for"
ltr_tb$class <- "ltr"

# remove extra column from ltr samples
ltr_tb$id <- NULL

# merge tables
output_tb <- rbind(for_tb, ltr_tb)

write.csv(output_tb, "~/Documents/jgeotec2020/tables/output_samples_all_with_ndmi.csv")




# Just Tables - Bigger Samples Version ------------------------------------
for_tb <- read.csv("~/Documents/jgeotec2020/tables/testes_bhrsj_257_pnts/samples_forest_bhrsj_swir2.csv") # Load for samples
ltr_tb <- read.csv("~/Documents/jgeotec2020/tables/testes_bhrsj_257_pnts/ltr_bhrsj_swir2.csv") # Load ltr samples
other_tb <- read.csv("~/Documents/jgeotec2020/tables/other_swir2.csv") # Load ltr samples

cid_len <- length(for_tb$system.index)
cid_len_double <- 503
for_tb$CID <- rep(1:cid_len)
ltr_tb$CID <- rep((cid_len + 1):cid_len_double)
ltr_tb$VALUE <- NULL
other_tb$CID <- rep(504:755)
other_tb$VALUE <- NULL

# create class column
for_tb$class <- "for"
ltr_tb$class <- "ltr"
other_tb$class <- "oth"
# remove extra column from ltr samples
# ltr_tb$id <- NULL

# merge tables
output_tb <- rbind(for_tb, ltr_tb, other_tb)

write.csv(output_tb, "~/Documents/jgeotec2020/tables/output_samples_swir2.csv")



