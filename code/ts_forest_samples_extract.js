var geet = require('users/elacerda/geet:geet'); 
var ts_collection = geet.build_annual_landsat_timeseries(roi);

var clip_image = function(image) {
  return image.clip(roi);
};
var ts_clipped = ts_collection.map(clip_image);

var merge_bands = function(image, previous) {
  return ee.Image(previous).addBands(image);
};
var ts_stack = ts_clipped.iterate(merge_bands, ee.Image([]));

var ts_final = ee.Image(ts_stack)

print(ts_final)

var input_features = ts_final.sampleRegions({
  collection: af_samples,
  scale: 30
});

Export.table.toDrive({
  collection: input_features,
  description:'forest_samples',
  fileFormat: 'SHP'
});