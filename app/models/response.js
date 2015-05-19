var mongoose = require('mongoose'),
  Schema = mongoose.Schema;
var RoundResponseSchema = require('../models/roundResponse.js');


var ResponseSchema = new Schema({
  userId: String,
  complete: Boolean,
  responses: [RoundResponseSchema]
});

ResponseSchema.virtual('date')
  .get(function(){
    return this._id.getTimestamp();
  });

mongoose.model('Response', ResponseSchema);

