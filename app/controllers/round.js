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
    Response.findOne({ userId: userId }).exec()
      .then(function (response) {

      var completed = (roundNumber >= count);

      if (req.body.submitType === 'consent') {
        response.consent = true;
      } else if (req.body.submitType === 'preAnxiety') {
        response.preAnxiety = req.body.anxiety;
      } else if (req.body.submitType === 'postAnxiety') {
        response.postAnxiety = req.body.anxiety;
      }

      if ((nextRoundNumber !== 1) && (roundNumber <= count)) {
        if (!response.responses[parseInt(req.body.roundNumber) - 1]) {
          response.complete = completed;
          response.responses.push({
            roundNumber: parseInt(req.body.roundNumber),
            questionTypePicked: req.body.questionTypePicked,
            qTypePicked: req.body.qTypePicked,
            questionTime: parseInt(req.body.questionTime),
            decision: req.body.decision,
            decisionTime: parseInt(req.body.decisionTime)
          });
        }
      }

      response.save();

      if (parseInt(response.preAnxiety) === -1) {
        res.render('anxiety', {
          title: 'TODO: title',
          userId: userId,
          roundNumber: 0,
          anxietyType: 'preAnxiety'
        });
        return;
      }

      if (completed) {
        if (parseInt(response.postAnxiety) === -1) {
          res.render('anxiety', {
            title: 'Anxiety',
            userId: userId,
            roundNumber: nextRoundNumber,
            anxietyType: 'postAnxiety'
          });
          return;
        } else {
          res.redirect('/complete');
          return;
        }
      }

      Round.findOne({ roundNumber: nextRoundNumber }).exec()
      .then(function (round) {
        round.userId = userId;
        res.render('round', {
          title: 'TODO',
          question: round
        });
        return;
      });
    });
  });
});