var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Question = mongoose.model('Question'),
  Response = mongoose.model('Response'),
  Promise = require('bluebird');

Promise.promisifyAll(mongoose);

module.exports = function (app) {
  app.use('/question', router);
};

router.post('/question', function (req, res, next) {
  Article.find(function (err, articles) {
    if (err) return next(err);

    var nextRoundNumber = req.body.roundNumber + 1,
      userId = req.body.userId,


    var answer = new Response(req.body.userResponse);
    answer.save()
      .then(function() {
        return Quesiton.findOne({ roundNumber: nextRoundNumber });
      })
      .then(function (question) {
        res.render('question', {
          title: 'TODO: Change this title to something appropriate',
          question: question
        });
      });
  });
});
