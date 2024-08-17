const Restaurant = require('../models/restaurant');

// Create a new restaurant
exports.createRestaurant = async (req, res) => {
  try {
    const { name, location, rating, distance, reviews } = req.body;

    const newRestaurant = new Restaurant({
      name,
      location,
      rating,
      distance,
      reviews,
    });

    const savedRestaurant = await newRestaurant.save();
    res.status(201).json(savedRestaurant);
  } catch (error) {
    res.status(500).json({ message: 'Error creating restaurant', error });
  }
};

// Get all restaurants
exports.getAllRestaurants = async (req, res) => {
  try {
    const restaurants = await Restaurant.find();
    res.status(200).json(restaurants);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching restaurants', error });
  }
};

// Get a single restaurant by ID
exports.getRestaurantById = async (req, res) => {
  try {
    const restaurant = await Restaurant.findById(req.params.id);

    if (!restaurant) {
      return res.status(404).json({ message: 'Restaurant not found' });
    }

    res.status(200).json(restaurant);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching restaurant', error });
  }
};

// Update a restaurant by ID
exports.updateRestaurant = async (req, res) => {
  try {
    const { name, location, rating, distance, reviews } = req.body;

    const updatedRestaurant = await Restaurant.findByIdAndUpdate(
      req.params.id,
      { name, location, rating, distance, reviews },
      { new: true, runValidators: true }
    );

    if (!updatedRestaurant) {
      return res.status(404).json({ message: 'Restaurant not found' });
    }

    res.status(200).json(updatedRestaurant);
  } catch (error) {
    res.status(500).json({ message: 'Error updating restaurant', error });
  }
};

// Delete a restaurant by ID
exports.deleteRestaurant = async (req, res) => {
  try {
    const deletedRestaurant = await Restaurant.findByIdAndDelete(req.params.id);

    if (!deletedRestaurant) {
      return res.status(404).json({ message: 'Restaurant not found' });
    }

    res.status(200).json({ message: 'Restaurant deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting restaurant', error });
  }
};
