// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var RoundResponseSchema = new Schema({
    roundNumber:  Number,
    questionTypePicked: String,
    questionTime: Number,
    decision:     String,
    decisionTime: Number
});

module.exports = RoundResponseSchema;