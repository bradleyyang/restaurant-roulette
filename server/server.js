require('dotenv').config();
const mongoose = require('mongoose');
const Restaurant = require('./models/restaurant');

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

app.get('/restaurants/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const restaurant = await Restaurant.findById(id);

    if (!restaurant) {
      return res.status(404).send({ message: 'Restaurant not found' });
    }

    res.send(restaurant);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.delete('/restaurants', async (req, res) => {

})