// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var QuestionSchema = new Schema({ text: String, type: String, qType: String, answer: String});
var RoundSchema = new Schema({
  roundNumber: Number,
  itemName: String,
  image: String,
  questions: [QuestionSchema]
});

RoundSchema.virtual('date').get(function(){
  return this._id.getTimestamp();
});

mongoose.model('Round', RoundSchema);

