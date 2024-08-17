require('dotenv').config();
const mongoose = require('mongoose');

const bodyParser = require('body-parser');
const port = process.env.PORT || 3000

const express = require('express')
const app = express()

app.get('/', (req, res) => {
  res.send('Hello World!')
})



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