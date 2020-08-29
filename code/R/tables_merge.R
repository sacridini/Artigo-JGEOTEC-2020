out_tb_blue <- read.csv("~/Documents/jgeotec2020/tables/output_samples_blue.csv")
out_tb_green <- read.csv("~/Documents/jgeotec2020/tables/output_samples_green.csv")
out_tb_red <- read.csv("~/Documents/jgeotec2020/tables/output_samples_red.csv")
out_tb_nir <- read.csv("~/Documents/jgeotec2020/tables/output_samples_nir.csv")
out_tb_swir1 <- read.csv("~/Documents/jgeotec2020/tables/output_samples_swir1.csv")
out_tb_swir2 <- read.csv("~/Documents/jgeotec2020/tables/output_samples_swir2.csv")
out_tb_ndvi <- read.csv("~/Documents/jgeotec2020/tables/output_samples_ndvi.csv")
out_tb_ndwi <- read.csv("~/Documents/jgeotec2020/tables/output_samples_ndwi.csv")
out_tb_ndmi <- read.csv("~/Documents/jgeotec2020/tables/output_samples_ndmi.csv")
out_tb_savi <- read.csv("~/Documents/jgeotec2020/tables/output_samples_savi.csv")
out_tb_greenness <- read.csv("~/Documents/jgeotec2020/tables/output_samples_greenness.csv")
out_tb_wetness <- read.csv("~/Documents/jgeotec2020/tables/output_samples_wetness.csv")
out_tb_brightness <- read.csv("~/Documents/jgeotec2020/tables/output_samples_brightness.csv")

b_g <- merge(out_tb_blue, out_tb_green, key = "CID")
b_g_r <- merge(b_g, out_tb_red, key = "CID")
b_g_r_nir <- merge(b_g_r, out_tb_nir, key = "CID")
sw1_sw2 <- merge(out_tb_swir1, out_tb_swir2, key = "CID")
b_g_r_nir_sw1_sw2 <- merge(b_g_r_nir, sw1_sw2, key = "CID") # raw
ndvi_ndwi <- merge(out_tb_ndvi, out_tb_ndwi, key = "CID")
ndmi_savi <- merge(out_tb_ndmi, out_tb_savi, key = "CID")
ndvi_ndwi_ndmi_savi <- merge(ndvi_ndwi, ndmi_savi, key = "CID") # idx
ndvi_ndmi <- merge(out_tb_ndvi, out_tb_ndmi, key = "CID")
nir_ndvi_ndmi <- merge(out_tb_nir, ndvi_ndmi, key = "CID")
b_g_r_nir_sw1_sw2_ndvi_ndwi_ndmi_savi <- merge(b_g_r_nir_sw1_sw2, ndvi_ndwi_ndmi_savi, key = "CID") # raw_idx
greenness_wetness <- merge(out_tb_greenness, out_tb_wetness, key = "CID")
tc <- merge(greenness_wetness, out_tb_brightness, key = "CID")# tc
tc_ndvi_ndwi_ndmi_savi <- merge(ndvi_ndwi_ndmi_savi, tc, key = "CID") # tc_idx
all <- merge(b_g_r_nir_sw1_sw2_ndvi_ndwi_ndmi_savi, tc, key = "CID") # all
nir_ndvi <- merge(out_tb_ndvi, out_tb_nir, key = "CID") # all

write.csv(b_g, "~/Documents/jgeotec2020/tables/output_samples_b_g.csv")
write.csv(b_g_r, "~/Documents/jgeotec2020/tables/output_samples_b_g_r.csv")
write.csv(b_g_r_nir, "~/Documents/jgeotec2020/tables/output_samples_b_g_r_nir.csv")
write.csv(b_g_r_nir_sw1_sw2, "~/Documents/jgeotec2020/tables/output_samples_b_g_r_nir_sw1_sw2.csv")
write.csv(ndvi_ndwi_ndmi_savi, "~/Documents/jgeotec2020/tables/output_samples_ndvi_ndwi_ndmi_savi.csv")
write.csv(ndvi_ndmi, "~/Documents/jgeotec2020/tables/output_samples_ndvi_ndmi.csv")
write.csv(nir_ndvi, "~/Documents/jgeotec2020/tables/output_samples_nir_ndvi.csv")
write.csv(nir_ndvi_ndmi, "~/Documents/jgeotec2020/tables/output_samples_nir_ndvi_ndmi.csv")
write.csv(tc, "~/Documents/jgeotec2020/tables/output_samples_tc.csv")
write.csv(tc_ndvi_ndwi_ndmi_savi, "~/Documents/jgeotec2020/tables/output_samples_tc_ndvi_ndwi_ndmi_savi.csv")
write.csv(b_g_r_nir_sw1_sw2_ndvi_ndwi_ndmi_savi, "~/Documents/jgeotec2020/tables/output_samples_b_g_r_nir_sw1_sw2_ndvi_ndwi_ndmi_savi.csv")
write.csv(all, "~/Documents/jgeotec2020/tables/output_samples_all.csv")
