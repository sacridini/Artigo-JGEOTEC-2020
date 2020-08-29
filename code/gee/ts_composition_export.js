var geet = require('users/elacerda/geet:geet'); 
var ts_collection = geet.build_annual_landsat_timeseries(roi);
print(ts_collection)
var clip_image = function(image) {
  return image.clip(roi);
};
var ts_clipped = ts_collection.map(clip_image);

var merge_bands = function(image, previous) {
  return ee.Image(previous).addBands(image);
};
var ts_final = ts_clipped.iterate(merge_bands, ee.Image([]));


print(ee.Image(ts_final))

Export.image.toDrive({
  image: ee.Image(ts_final).toFloat(), 
  description: "ts_final", 
  folder: 'ee', 
  fileNamePrefix: "ts_final", 
  region: roi,
  scale: 30, 
  crs: 'EPSG:4326', 
  maxPixels: 1e13
});
