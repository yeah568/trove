// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var ResponseSchema = new Schema({

  userId: String,
  responses: [{
    roundNumber:  Number,
    questionType: Number,
    questionTime: Number,
    decision:     Boolean,
    decisionTime: Number
  }],

});

ResponseSchema.virtual('date')
  .get(function(){
    return this._id.getTimestamp();
  });

mongoose.model('Response', ResponseSchema);

