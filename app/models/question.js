// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var QuestionSchema = new Schema({
  roundNumber: Number,
  itemName: String,
  question1: { text: String, type: Number, answer: String },
  question2: { text: String, type: Number, answer: String }
});

QuestionSchema.virtual('date')
  .get(function(){
    return this._id.getTimestamp();
  });

mongoose.model('Question', QuestionSchema);

