var geet = require('users/elacerda/geet:geet'); 

for (var i = 0; i < 3; i++) {
  switch(i) {
    case 0:
      af_samples = af_samples.map(function(feature) { return feature.set('class', i); });
    case 1:
      ltr_samples = ltr_samples.map(function(feature) { return feature.set('class', i); });
    case 2:
      other_samples = other_samples.map(function(feature) { return feature.set('class', i); });
  }
}

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


// var imgClass = geet.rf(ee.Image(img_ts), bands, samplesfc, 'class', 100, 30, 0.7);

var input_features = ee.Image(img_ts).sampleRegions({
  collection: samplesfc,
  properties: ['class'],
  scale: 30
});

var classifier_final = ee.Classifier.smileRandomForest(10).setOutputMode('PROBABILITY').train({
  features: input_features,
  classProperty: 'class',
  inputProperties: bands
});

var imgClass = ee.Image(img_ts).classify(classifier_final);

var dict = classifier_final.explain();
print('Explain: ', dict);

var variable_importance = ee.Feature(null, ee.Dictionary(dict).get('importance'));

var chart = 
  ui.Chart.feature.byProperty(variable_importance)
    .setChartType('ColumnChart')
    .setOptions({
      title: 'Random Forest Variable Importance',
      legend: {position: 'none'},
      hAxis: {title: 'Bands'},
      vAxis: {title: 'Importance'}
    });

print(variable_importance)
print(chart);
print(imgClass);
Map.addLayer(imgClass);

Export.table.toDrive({
  collection: ee.FeatureCollection(variable_importance), 
  description: "dict", 
  folder: 'ee'
});

Export.image.toDrive({
  image: imgClass.unmask(4).clip(roi), 
  description: "imgClass", 
  folder: 'ee', 
  fileNamePrefix: "imgClass", 
  region: roi,
  scale: 30, 
  crs: 'EPSG:4326', 
  maxPixels: 1e13
});


