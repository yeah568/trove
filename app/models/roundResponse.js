// Example model

var mongoose = require('mongoose'),
  Schema = mongoose.Schema;

var RoundResponseSchema = module.exports = new Schema({
    roundNumber:  Number,
    questionTypePicked: String,
    questionTime: Number,
    decision:     String,
    decisionTime: Number
});

module.exports = mongoose.model('RoundResponse', RoundResponseSchema);