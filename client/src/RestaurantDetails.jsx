import React, { useEffect, useState } from 'react';
import axios from 'axios';

const RestaurantDetails = () => {
  const [restaurant, setRestaurant] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false); // New state for loading
  const [showRestaurant, setShowRestaurant] = useState(false); // New state for showing restaurant

  const fetchRestaurant = async () => {
    setLoading(true); // Set loading to true when starting to fetch
    setError(null); // Clear any previous errors

    try {
      const response = await axios.get('http://localhost:3000/restaurant');

      if (response.status === 404) {
        throw new Error('Restaurant not found');
      }

      setRestaurant(response.data);
      setShowRestaurant(true); // Show restaurant details after fetching
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false); // Set loading to false after fetching
    }
  };

  const closeDetails = () => {
    setShowRestaurant(false); // Hide restaurant details
    setRestaurant(null); // Clear restaurant data
  };

  return (
    <div>
      <button onClick={fetchRestaurant}>Show Restaurant Details</button>

      {loading && <p>Loading...</p>} {/* Show loading text when fetching */}

      {error && <div>Error: {error}</div>} {/* Show error message if any */}

      {showRestaurant && restaurant && ( // Show restaurant details only when the button is clicked
        <div>
          <h1>{restaurant.name}</h1>
          <p>Address: {restaurant.formatted_address}</p>
          <p>Rating: {restaurant.rating} ⭐</p>
          <p>Distance: {restaurant.distance} km</p>
          <p>Price Level: {restaurant.price_level}</p>
          <p>Total Ratings: {restaurant.user_ratings_total}</p>
          <p>{restaurant.open_now ? "Open Now" : "Closed"}</p>
          <button onClick={closeDetails}>Close</button> {/* Close button */}
        </div>
      )}
    </div>
  );
};

export default RestaurantDetails;