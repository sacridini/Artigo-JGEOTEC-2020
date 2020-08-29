# rm(list = ls()); gc()
library(mlr)
library(raster)


# Read as Shapefile -------------------------------------------------------
# amostras <- raster::shapefile("~/Documents/jgeotec2020/vector/output_samples.shp")
# amostras_df <- as.data.frame(amostras)

# Or read as .csv ---------------------------------------------------------
amostras_df <- read.csv("~/Documents/jgeotec2020/tables/output_samples_brightness.csv", stringsAsFactors = FALSE)

amostras_df$CID <- NULL
amostras_df$system.index <- NULL
amostras_df$.geo <- NULL
amostras_df$X.1 <- NULL
amostras_df$X <- NULL

# MLR ---------------------------------------------------------------------
rTask <- mlr::makeClassifTask(data = amostras_df, target = "class") # cria task
rf = mlr::makeLearner("classif.randomForest", predict.type = "prob") # cria learner
rfModel <- mlr::train(rf, rTask) # treina modelo
kFold <- mlr::makeResampleDesc("RepCV", folds = 10, reps = 50)
rfFoldCV <- mlr::resample(learner = rf, task = rTask, resampling = kFold, measures = list(mmce, kappa)) 


mlr::calculateConfusionMatrix(rfFoldCV$pred) # (optional)
fv <- mlr::generateFilterValuesData(rTask, method = "FSelectorRcpp_information.gain") # (optional)
mlr::plotFilterValues(fv, filter = "FSelectorRcpp_information.gain") # (optional)
mlr::getFeatureImportance(rfModel) # (optional)

# Raster Classification ---------------------------------------------------
# r_df <- as.data.frame(as.matrix(r)) # transforma o raster em data.frame (necessário)
# r_df$value <- 0 # adiciona uma coluna para os valores finais
# pred_raster_rf <- predict(object = rfModel, newdata = r_df) # gera a classificação
# pred_raster <- r[[1]] # cria um raster (output)
# pred_raster[] <- pred_raster_rf$data$response # Seta os valores finais no raster de saída (output)
# plot(pred_raster) # plota a classificação
# writeRaster(pred_raster, "~/Documents/curso_rf/output_class.tif", options = "COMPRESS=DEFLATE") # Salva o arquivo final