require('dotenv').config();
const mongoose = require('mongoose');
const Restaurant = require('./models/restaurant');
const axios = require('axios');

const port = process.env.PORT || 3000

const express = require('express')
const app = express()
app.use(express.json());





mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log('Connected to the database')
    app.listen(port, () => {
      console.log(`Listening on port ${port}`)
    })
  })
  .catch((error) => {
    console.log(error)
  })


// Routes
app.post('/restaurants', async (req, res) => {
  const restaurant = new Restaurant(req.body);
  await restaurant.save();
  res.send(restaurant);
});

app.get('/restaurants', async (req, res) => {
  try {
    const restaurants = await Restaurant.find({});
    res.send(restaurants);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.get('/restaurant', async (req, res) => {
  try {
    const query = { name: "Bob's Burgers" };
    const restaurant = await Restaurant.findOne(query);

    if (!restaurant) {
      return res.status(404).send({ message: 'Restaurant not found' });
    }

    res.send(restaurant);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.delete('/restaurants', async (req, res) => {
  const query = { name: "David" };
  const deleteResult = await Restaurant.deleteOne(query);
  res.send(deleteResult);
});

app.put('/restaurants', async (req, res) => {
  const filter = { name: "Starbucks" };

  // this option instructs the method to create a document if no documents match the filter
  const options = { upsert: true };
  // create a document that sets the distance
  const updateDoc = {
    $set: {
      name: "McDonalds",
      open_now: true,
      formatted_address: "5555 Dundas St W",
      rating: 4.0,
      distance: 1.2,
      price_level: 3,
      user_ratings_total: 100
    },
  };

  const updateResult = await Restaurant.updateOne(filter, updateDoc, options);
  res.send(updateResult);
});


app.get('/restaurant-details', async (req, res) => {
  // Replace with the actual place ID you want to use
  const placeId = 'ChIJ5_4bHL43K4gRlMRkVLS4ONg'; // Example place ID
  const fields = 'name,rating,formatted_address,opening_hours,reviews'; // Fields you want to retrieve

  const url = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&fields=${fields}&key=${process.env.GOOGLE_API_KEY}`;

  try {
    // Make the HTTP request to the Google Places API
    const response = await axios.get(url);

    // Send the API response data back to the client
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching restaurant details:', error.message);
    res.status(500).json({ error: 'Failed to fetch restaurant details' });
  }
});

app.get('/nearby-restaurants', async (req, res) => {
  // Extract query parameters from the request
  const { keyword = 'restaurant', location = '43.6329141,-79.5445094', radius = 1500, type = 'restaurant' } = req.query;

  // Construct the URL dynamically using the parameters
  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=${encodeURIComponent(keyword)}&location=${encodeURIComponent(location)}&radius=${radius}&type=${type}&key=${process.env.GOOGLE_API_KEY}`;

  try {
    // Make the HTTP request to the Google Places API
    const response = await axios.get(url);

    // Send the API response data back to the client
    res.json(response.data);
  } catch (error) {
    console.error('Error fetching nearby restaurants:', error.message);
    res.status(500).json({ error: 'Failed to fetch nearby restaurants' });
  }
});