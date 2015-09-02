var express = require('express'),
  router = express.Router(),
  mongoose = require('mongoose'),
  Round = mongoose.model('Round'),
  Response = mongoose.model('Response'),
  json2csv = require('json2csv'),
  fs = require('fs'),
  auth = require('http-auth'),
  pass = require('pass'),
  cdm = require('connect-dynamic-middleware');

module.exports = function (app) {
  app.use('/admin', router);
};

var basic = auth.basic({
    realm: 'Admin',
    file: __base + 'config/admin.htpasswd'
});
var authMiddleware = cdm(auth.connect(basic));

router.get('/', authMiddleware, function (req, res, next) {
  next();
}, renderAdmin);

router.post('/', authMiddleware, function (req, res, next) {
  res.locals.renderOptions = {};
  if (req.body.submit == 'round') {
    var round = new Round({
      roundNumber: req.body.roundNumber,
      itemName: req.body.itemName,
      image: req.files.image.name,
      questions: [{
        text: req.body.q1text,
        type: req.body.q1type,
        qType: req.body.q1qtype,
        answer: req.body.q1answer
      }, {
        text: req.body.q2text,
        type: req.body.q2type,
        qType: req.body.q2qtype,
        answer: req.body.q2answer
      }]
    });
    round.save(function (err, res) {
      next();
    });
  } else if (req.body.submit == 'response') {
    Response.find({ userId: req.body.userId }).limit(1).exec()
    .then(function(response) {
      if (response.length == 0) {
        var r = new Response({
          userId: req.body.userId,
          complete: false,
          responses: []
        });
        r.save(function() {
          next();
        });
      } else {
        res.locals.renderOptions['error'] = "User " + req.body.userId + " already exists.";
        next();
      }
    });
  } else if (req.body.submit == 'text') {
      fs.writeFile(__base + 'config/settings.json',
      JSON.stringify({ endText: req.body.endtext, consentText: req.body.consenttext }),
      function (err) {
        next();
      });
  } else if (req.body.submit == 'account') {
    pass.generate(req.body.password, function (err, hash) {
      if (err) {
        return console.log('Error: ' + err);
      }
      console.log(hash);
      var htpasswd = req.body.username + ':' + hash;
      fs.writeFile(__base + 'config/admin.htpasswd',
        htpasswd,
        function (err) {
          basic = auth.basic({
            realm: 'Admin',
            file: __base + 'config/admin.htpasswd'
          })
          authMiddleware.setMiddleware(auth.connect(basic));
          next();
        });
    });
  } else {
    next();
  }
}, renderAdmin);

router.get('/download', authMiddleware, function (req, res, next) {
  var parsed = [];
  Response.find({}).exec()
  .then(function (responses) {
    var max = 0;
    var maxIndex = 0;
    responses.forEach(function (response, i) {
      // create data objects
      var r = {
        userId: response.userId,
        complete: response.complete,
        preAnxiety: response.preAnxiety,
        postAnxiety: response.postAnxiety
      };
      response.responses.forEach(function (rr, i) {
        r['rr' + rr.roundNumber + 'qtp'] = rr.questionTypePicked;
        r['rr' + rr.roundNumber + 'qType'] = rr.qTypePicked;
        r['rr' + rr.roundNumber + 'qt'] = rr.questionTime;
        r['rr' + rr.roundNumber + 'd'] = rr.decision;
        r['rr' + rr.roundNumber + 'dt'] = rr.decisionTime;
      })
      parsed.push(r);
      
      if (response.responses.length > max) {
        max = response.responses.length;
        maxIndex = i;
      }
    });

    // create fields for csv
    var fields = ['userId', 'preAnxiety', 'postAnxiety'];
    var fieldNames = ['User ID', 'Pre Anxiety', 'Post Anxiety'];
    responses[maxIndex].responses.forEach(function (rr, i) {
      fields.push('rr' + rr.roundNumber + 'qtp');
      fields.push('rr' + rr.roundNumber + 'qType');
      fields.push('rr' + rr.roundNumber + 'qt');
      fields.push('rr' + rr.roundNumber + 'd');
      fields.push('rr' + rr.roundNumber + 'dt');
      fieldNames.push('Round ' + rr.roundNumber + " I-Type Picked");
      fieldNames.push('Round ' + rr.roundNumber + " Q-Type Picked");
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

router.post('/delete', authMiddleware, function (req, res, next) {
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
});

router.post('/move', authMiddleware, function (req, res, next) {
  var num = parseInt(req.body.id);
  if (req.body.direction == 'up') {
    Round.find({ roundNumber: num - 1 }).exec()
    .then(function(rounds) {
      if (rounds.length > 0) {
        res.send('Already exists a round ' + (num - 1) + '. Move failed.');
      } else {
        Round.findOne({ roundNumber: num }).exec()
        .then(function(round) {
          round.roundNumber = num - 1;
          round.save(function() {
            res.send('Moved! Refreshing...');
          });
        })
      }
    });
  } else if (req.body.direction == 'down') {
    Round.find({ roundNumber: num + 1 }).exec()
    .then(function(rounds) {
      if (rounds.length > 0) {
        res.send('Already exists a round ' + (num + 1) + '. Move failed.');
      } else {
        Round.findOne({ roundNumber: num }).exec()
        .then(function(round) {
          round.roundNumber = num + 1;
          round.save(function() {
            res.send('Moved! Refreshing...');
          });
        })
      }
    });
  }
});

function renderAdmin(req, res) {
  var options = {
    title: 'Admin // Trove'
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
    fs.readFile(__base + 'config/settings.json', function (err, config) {
      try {
        var parsed = JSON.parse(config);
        options.endText = parsed.endText;
        options.consentText = parsed.consentText;
        fs.readFile(__base + 'config/admin.htpasswd', "utf-8", function (err, credentials) {
          if (err) {
            return console.log(err);
          };
          options.username = credentials.split(':')[0];
          res.render('admin', options);
        });
      }
      catch (err) {
        return console.log(err);
      }
    });
  });
}