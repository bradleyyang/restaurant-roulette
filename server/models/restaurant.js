const mongoose = require('mongoose');

const restaurantSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  location: {
    type: {
      type: String, 
      enum: ['Point'], 
      required: true,
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true,
    },
  },
  rating: {
    type: Number,
    required: true,
    min: 0,
    max: 5,
  },
  distance: {
    type: Number, 
    required: true,
  },
  reviews: [{
    user: {
      type: String,
      required: true,
    },
    comment: {
      type: String,
      required: true,
    },
    rating: {
      type: Number,
      required: true,
      min: 0,
      max: 5,
    },
    date: {
      type: Date,
      default: Date.now,
    },
  }],
});

// Create a geospatial index on the location field
restaurantSchema.index({ location: '2dsphere' });

const Restaurant = mongoose.model('Restaurant', restaurantSchema);

module.exports = Restaurant;
