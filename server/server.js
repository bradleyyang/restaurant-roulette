require('dotenv').config();
const mongoose = require('mongoose');
const axios = require('axios');

const port = process.env.PORT || 3000;

const express = require('express');
const app = express();
const cors = require('cors');
app.use(cors());
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

app.get('/restaurant-details', async (req, res) => {
  const placeName = req.query.place_name;
  const apiKey = process.env.GOOGLE_API_KEY;
  

  const findPlaceEndpoint = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${placeName}&inputtype=textquery&key=${apiKey}`;
  
  try {
    const placeIDResponse = await axios.get(findPlaceEndpoint);
    const placeID = placeIDResponse.data.candidates[0].place_id;
    

    if (!placeID) {
      return res.status(404).json({ message: 'Place not found' });
    }


    const fields = 'name,rating,formatted_address,opening_hours,reviews';
    const placeDetailsEndpoint = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeID}&fields=${fields}&key=${apiKey}`;
    
    const placeDetailsResponse = await axios.get(placeDetailsEndpoint);
    res.status(200).json(placeDetailsResponse.data);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to get restaurant details' });
  }
});


app.get('/nearby-restaurants', async (req, res) => {
  const geolocationurl = `https://www.googleapis.com/geolocation/v1/geolocate?key=${process.env.GOOGLE_API_KEY}`;

  try {
    const geoResponse = await axios.post(geolocationurl, {});
    const { lat, lng } = geoResponse.data.location;

    const { keyword = 'restaurant', location = `${lat},${lng}`, radius = 1500, type = 'restaurant' } = req.query;

    const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=${encodeURIComponent(keyword)}&location=${encodeURIComponent(location)}&radius=${radius}&type=${type}&key=${process.env.GOOGLE_API_KEY}`;

    const response = await axios.get(url);

    res.json(response.data);
  } catch (error) {
    console.error('Error fetching nearby restaurants:', error.message);
    res.status(500).json({ error: 'Failed to fetch nearby restaurants' });
  }
});


