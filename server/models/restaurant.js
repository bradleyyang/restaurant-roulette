const mongoose = require('mongoose');

const restaurantSchema = new mongoose.Schema({
  name: String,
  open_now: Boolean,
  formatted_address: String,
  rating: Number,
  distance: Number,
  price_level: Number,
  user_ratings_total: Number
});

const Restaurant = mongoose.model('Restaurant', restaurantSchema);

module.exports = Restaurant;
