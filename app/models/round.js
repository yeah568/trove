// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var QuestionSchema = new Schema({ text: String, type: String, answer: String});
var RoundSchema = new Schema({
  roundNumber: Number,
  itemName: String,
  questions: [QuestionSchema]
});

RoundSchema.virtual('date').get(function(){
  return this._id.getTimestamp();
});

mongoose.model('Round', RoundSchema);

