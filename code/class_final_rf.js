var roi = ee.FeatureCollection("users/elacerda/bhrsj"),
    af_samples = ee.FeatureCollection("users/elacerda/samples_forest_sj"),
    ltr_samples = ee.FeatureCollection("users/elacerda/ltr_loss_samples"),
    other_samples = ee.FeatureCollection("users/elacerda/other_samples"),
    img_ts = ee.Image("users/elacerda/bhrsj_ts");

var geet = require('users/elacerda/geet:geet'); 

var set_prop = function(feature) {
  return feature.set('class', 0);
}
var af_samples = af_samples.map(set_prop)

var set_prop = function(feature) {
  return feature.set('class', 1);
}
var ltr_samples = ltr_samples.map(set_prop)

var set_prop = function(feature) {
  return feature.set('class', 2);
}
var other_samples = other_samples.map(set_prop)

var samplesfc = af_samples.merge(ltr_samples).merge(other_samples);

var bands = [];
for (var i = 0; i < 32; i++) {
  if (i === 0) {
    bands.push("BLUE");
    bands.push("GREEN");
    bands.push("RED");
    bands.push("SWIR1");
    bands.push("SWIR2");
    bands.push("NIR");
    bands.push("NDVI");
    bands.push("NDMI");
    bands.push("SAVI");
  } else {
    bands.push("BLUE_" + i.toString());
    bands.push("GREEN_" + i.toString());
    bands.push("RED_" + i.toString());
    bands.push("SWIR1_" + i.toString());
    bands.push("SWIR2_" + i.toString());
    bands.push("NIR_" + i.toString());
    bands.push("NDVI_" + i.toString());
    bands.push("NDMI_" + i.toString());
    bands.push("SAVI_" + i.toString());
  }
}


var imgClass = geet.rf(ee.Image(img_ts), bands, samplesfc, 'class', 100, 30, 0.7);
print(imgClass)
Map.addLayer(imgClass)