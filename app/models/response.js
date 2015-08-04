var mongoose = require('mongoose'),
  Schema = mongoose.Schema;
var RoundResponseSchema = require('../models/roundResponse.js');


var ResponseSchema = new Schema({
  userId: String,
  consent: { type: Boolean, default: false },
  instructions: { type: Boolean, default: false },
  complete: Boolean,
  preAnxiety: { type: Number, default: -1},
  postAnxiety: { type: Number, default: -1},
  responses: [RoundResponseSchema]
});

ResponseSchema.virtual('date')
  .get(function(){
    return this._id.getTimestamp();
  });

mongoose.model('Response', ResponseSchema);

