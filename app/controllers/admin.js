var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Round = mongoose.model('Round'),
  Response = mongoose.model('Response'),
  RoundResponse = require('../models/roundResponse.js'),
  Promise = require('bluebird');

Promise.promisifyAll(mongoose);

module.exports = function (app) {
  app.use('/round', router);
};
router.get('/', function (req, res, next) {
  // change to get first question that's not done
  Round.findOne({ roundNumber: 1 })
  .then(function (round) {
    res.render('round', {
      title: 'question',
      question: round
    });
  });
});

router.post('/', function (req, res, next) {
  var nextRoundNumber = parseInt(req.body.roundNumber) + 1,
    userId = req.body.userId;

  if (!(nextRoundNumber === 1)) {
    var answer = new RoundResponse(req.body);
    answer.save();
  }

  Round.findOne({ roundNumber: nextRoundNumber }, function (err, round) {
    res.render('round', {
      title: 'TODO: Change this title to something appropriate',
      question: round
    });
  });
});





router.get('/create', function(req, res, next) {
  var r1 = new Round({
    roundNumber: 1,
    itemName: "Tennis Racket",
    questions: [{
      text: "How often have I used this in the past 2 years?",
      type: "Occasional",
      answer: "I might have used this once or twice in the past couple years, but I got tired of tennis after that."
    }, {
      text: "How often do I think I will use this in the next year?",
      type: "Experimental",
      answer: "I'm really into Yoga and Biking right now, so I probably won't take up tennis again for some time. "
    }]
  });
  r1.save();
  var r2 = new Round({
    roundNumber: 2,
    itemName: "Rain Poncho",
    questions: [{
      text: "When was the last time I used this?",
      type: "Typ Hoarded",
      answer: "I remember using this when I first bought it on a rainy day."
    }, {
      text: "How often do I think I will use this in the next year?",
      type: "Experimental",
      answer: "I probably won't use this at all in the next year. I prefer umbrellas."
    }]
  });
  r2.save();
  res.send('saved');
});
