var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Round = mongoose.model('Round'),
  Response = mongoose.model('Response'),
  json2csv = require('json2csv');

module.exports = function (app) {
  app.use('/admin', router);
};

router.get('/', function (req, res, next) {
  next();
}, renderAdmin);

router.post('/', function (req, res, next) {
  res.locals.renderOptions = {};
  if (req.body.submit == 'round') {
    console.log(req.files);
    console.log(req.files.image.name);
    var round = new Round({
      roundNumber: req.body.roundNumber,
      itemName: req.body.itemName,
      image: req.files.image.name,
      questions: [{
        text: req.body.q1text,
        type: req.body.q1type,
        answer: req.body.q1answer
      }, {
        text: req.body.q2text,
        type: req.body.q2type,
        answer: req.body.q2answer
      }]
    });
    round.save(function (err, res) {
      next();
    });
  } else if (req.body.submit == 'response') {
    Response.find({ userId: req.body.userId }).limit(1).exec()
    .then(function(response) {
      console.log('response hit');
      if (response.length == 0) {
        console.log('response not exists hit');
        var r = new Response({
          userId: req.body.userId,
          complete: false,
          responses: []
        });
        r.save(function() {
          console.log('response save hit');
          next();
        });
      } else {
        console.log('response exists hit');
        res.locals.renderOptions['error'] = "User " + req.body.userId + " already exists.";
        next();
        console.log('after next');
      }
    });
  } else {
    next();
  }
}, renderAdmin);

router.get('/download', function (req, res, next) {
  var parsed = [];
  Response.find({}).exec()
  .then(function (responses) {
    responses.forEach(function (response) {
      // create data objects
      var r = {
        userId: response.userId,
        complete: response.complete
      };
      response.responses.forEach(function (rr, i) {
        r['rr' + rr.roundNumber + 'qtp'] = rr.questionTypePicked;
        r['rr' + rr.roundNumber + 'qt'] = rr.questionTime;
        r['rr' + rr.roundNumber + 'd'] = rr.decision;
        r['rr' + rr.roundNumber + 'dt'] = rr.decisionTime;
      })
      parsed.push(r);  
    });

    // create fields for csv
    var fields = ['userId']
    var fieldNames = ['User ID'];
    responses[0].responses.forEach(function (rr, i) {
      fields.push('rr' + rr.roundNumber + 'qtp');
      fields.push('rr' + rr.roundNumber + 'qt');
      fields.push('rr' + rr.roundNumber + 'd');
      fields.push('rr' + rr.roundNumber + 'dt');
      fieldNames.push('Round ' + rr.roundNumber + " Question Type Picked");
      fieldNames.push('Round ' + rr.roundNumber + " Time to Quesiton Pick");
      fieldNames.push('Round ' + rr.roundNumber + " Decision");
      fieldNames.push('Round ' + rr.roundNumber + " Time to Decision");
    });
    json2csv({ data: parsed, fields: fields, fieldNames: fieldNames }, function(err, csv) {
      if (err) console.log(err); 
      var timestamp = "";
      timestamp = (new Date()).toISOString().slice(0,16).replace("T", "-");
      res.set({
        "Content-Type": "text\/csv",
        "Content-Disposition":"attachment; filename=\"UserResponses-" + timestamp + ".csv\""
      });
      res.send(csv);
    });
  })
});

router.post('/delete', function (req, res, next) {
  if (req.body.deleteType == 'round') {
    Round.find({ roundNumber: req.body.id }).remove().exec()
    .then(function() {
      res.send('Round ' + req.body.id + ' succesfully deleted.');
    });
  } else if (req.body.deleteType == 'user') {
    Response.find({ userId: req.body.id }).remove().exec()
    .then(function() {
      res.send('User ' + req.body.id + ' succesfully deleted.');
    });
  }
})

router.get('/login', function (req, res, next) {
    res.render('adminLogin', {
      title: 'admin login'
    })

});

function renderAdmin(req, res) {
  console.log('render hit');
  var options = {
    title: 'Admin'
  }

  if (res.locals.renderOptions) {
    for (var prop in res.locals.renderOptions) {
      options[prop] = res.locals.renderOptions[prop];
    }
  }

  Response.find({}).sort({userID:1}).exec()
  .then(function (responses) {
    options.responses = responses;
    return Round.find({}).sort({roundNumber:1}).exec()
  }).then(function (rounds) {
    options.rounds = rounds;
    res.render('admin', options);
  });
}