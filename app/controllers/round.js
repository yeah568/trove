var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Round = mongoose.model('Round'),
  Response = mongoose.model('Response'),
  Promise = require('bluebird');

Promise.promisifyAll(mongoose);

module.exports = function (app) {
  app.use('/round', router);
};

// shouldn't really be called?
router.get('/', function (req, res, next) {
  res.redirect('/start');
});

router.post('/', function (req, res, next) {
  var nextRoundNumber = parseInt(req.body.roundNumber) + 1,
    roundNumber = parseInt(req.body.roundNumber),
    userId = req.body.userId;


  Round.count().exec()
  .then(function (count) {
    var completed = (roundNumber >= count);


    if (nextRoundNumber !== 1) {
      Response.findOne({ userId: userId }).exec()
      .then(function (response) {
        if (!response.responses[parseInt(req.body.roundNumber) - 1]) {
          response.complete = completed;
          response.responses.push({
            roundNumber: parseInt(req.body.roundNumber),
            questionTypePicked: req.body.questionTypePicked,
            questionTime: parseInt(req.body.questionTime),
            decision: req.body.decision,
            decisionTime: parseInt(req.body.decisionTime)
          });
          response.save();
        }
      });
    }

    if (completed) {
      res.redirect('/complete');
      return;
    }

    Round.findOne({ roundNumber: nextRoundNumber }).exec()
    .then(function (round) {
      round.userId = userId;
      res.render('round', {
        title: 'TODO: Change this title to something appropriate',
        question: round
      });
    });
  });
});