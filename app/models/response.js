// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;
var RoundResponse = require('../models/roundResponse.js');


var ResponseSchema = new Schema({
  userId: String,
  responses: [RoundResponse]
});

ResponseSchema.virtual('date')
  .get(function(){
    return this._id.getTimestamp();
  });

mongoose.model('Response', ResponseSchema);

