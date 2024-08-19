const mongoose = require('mongoose');

const restaurantSchema = new mongoose.Schema({
  name: String,
  distance: Number
});

const Restaurant = mongoose.model('Restaurant', restaurantSchema);

module.exports = Restaurant;
