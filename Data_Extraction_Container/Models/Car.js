const mongoose = require('mongoose');

const cocheSchema = new mongoose.Schema({
  marca: {
    type: String,
    required: true
  },
  modelo: {
    type: String,
    required: true
  },
  año: {
    type: Number,
    required: true
  },
  color: {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('Car', cocheSchema);
