const express = require('express');
const router = express.Router();
const restaurantController = require('../controllers/restaurantController');
const Restaurant = require('../models/restaurant');
router.use(express.json());

const bodyParser = require('body-parser');
router.use(bodyParser.json());

// router.post('/restaurants', restaurantController.createRestaurant);
// router.get('/restaurants', restaurantController.getAllRestaurants);
// router.get('/restaurants/:id', restaurantController.getRestaurantById);
// router.put('/restaurants/:id', restaurantController.updateRestaurant);
// router.delete('/restaurants/:id', restaurantController.deleteRestaurant);

router.post('/restaurants', async (req, res) => {
    try {
        const restaurant = new Restaurant(req.body);
        await restaurant.save();
        res.status(201).send(restaurant);
    } catch (err) {
        res.status(400).send(err);
    }
});

router.get('/restaurants', async (req, res) => {
    try {
        const restaurants = await Restaurant.find({});
        res.send(restaurants);
    } catch (err) {
        res.status(500).send(err);
    }
});

module.exports = router;
