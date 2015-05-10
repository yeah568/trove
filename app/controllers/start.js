var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Round = mongoose.model('Round'),
  Response = mongoose.model('Response'),
  Promise = require('bluebird');

Promise.promisifyAll(mongoose);

module.exports = function (app) {
  app.use('/start', router);
};

router.get('/', function (req, res, next) {
  res.render('start', {
    title: 'Please log in.' // TODO: Change to whatever needed
  });
});

router.post('/', function (req, res, next) {
  var userId = req.body.userId;

  Response.findOne({ userId: userId }, function (err, response) {
    // if user has not been created
    if (!response) {
      res.render('start', {
        title: 'title',
        error: 'User ID not found. Please try again.'
      });
    } else {
      res.render('round', {
        title: 'TODO: Change this title to something appropriate',
        question: round
      });
    }
  });
});
