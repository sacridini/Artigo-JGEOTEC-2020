var geet = require('users/elacerda/geet:geet'); 
var ts_collection = geet.build_annual_landsat_timeseries(bhrsj);

var clip_image = function(image) {
  return image.clip(bhrsj);
};
var ts_clipped = ts_collection.map(clip_image);

var merge_bands = function(image, previous) {
  return ee.Image(previous).addBands(image);
};
var ts_stack = ts_clipped.iterate(merge_bands, ee.Image([]));

var ts_final = ee.Image(ts_stack)


var input_features = ts_final.sampleRegions({
  collection: other,
  scale: 30
});

print(input_features)

Export.table.toDrive({
  collection: input_features,
  description:'other_wetness',
  fileFormat: 'CSV'
});