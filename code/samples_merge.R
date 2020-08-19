rm(list = ls()); gc()

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



