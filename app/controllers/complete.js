var express = require('express'),
  router = express.Router();

module.exports = function (app) {
  app.use('/complete', router);
};

router.get('/', function (req, res, next) {
  res.render('complete', {
    title: 'Complete'
  });
});
