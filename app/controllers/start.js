var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Round = mongoose.model('Round'),
  Response = mongoose.model('Response'),
  Promise = require('bluebird'),
  fs = require('fs');

Promise.promisifyAll(mongoose);

module.exports = function (app) {
  app.use('/start', router);
};

router.get('/', function (req, res, next) {
  res.render('start', {
    title: 'Please log in.'
  });
});

router.post('/', function (req, res, next) {
  var userId = req.body.userId;

  Response.findOne({ userId: userId }).exec().then(function (response) {
    // if user has not been created
    if (!response) {
      res.render('start', {
        title: 'Please log in.',
        error: 'User ID not found. Please try again.'
      });
    } else {
      if (response.complete) {
        res.redirect('/complete');
      } else if (!response.consent) {
        fs.readFile(__base + 'config/settings.json', function (err, config) {
          res.render('consent', {
            consentText: JSON.parse(config).consentText,
            userId: userId
          });
        });
      } else if (parseInt(response.preAnxiety) === -1) {
        res.render('anxiety', {
          title: 'TODO: title',
          userId: userId,
          roundNumber: 0,
          anxietyType: 'preAnxiety'
        });
      } else {
        Round.findOne({ roundNumber: response.responses.length + 1 }).exec().then(function (round) {
          round.userId = userId;
          res.render('round', {
            title: 'TODO: Change this title to something appropriate',
            question: round
          });
        });
      }
    }
  });
});
