var express = require('express'),
  router = express.Router(),
  fs = require('fs');

module.exports = function (app) {
  app.use('/complete', router);
};

router.get('/', function (req, res, next) {
  fs.readFile(__base + 'config/settings.json', function (err, config) {
    try {
      var data = JSON.parse(config);
      res.render('complete', {
        title: 'Complete',
        text: data.endText
      });
    }
    catch (err) {
      console.log('There has been an error parsing your JSON.')
      console.log(err);
    }
  });
});
