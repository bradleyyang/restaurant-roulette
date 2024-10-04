import React, { useEffect, useState } from 'react';
import axios from 'axios';

const NearbyRestaurants = () => {
  const [restaurants, setRestaurants] = useState([]);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);
  const [showRestaurants, setShowRestaurants] = useState(false); // New state for showing restaurants

  const fetchNearbyRestaurants = async () => {
    setLoading(true);
    setError(null); // Reset error state before fetching
    try {
      const response = await axios.get('http://localhost:3000/nearby-restaurants');
      setRestaurants(response.data.results.slice(0, 5)); // Get the first 10 restaurants
      setShowRestaurants(true); // Show the restaurant list after fetching
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const closeRestaurants = () => {
    setShowRestaurants(false); // Hide the restaurant list
    setRestaurants([]); // Clear restaurant data
  };

  return (
    <div>
      <button onClick={fetchNearbyRestaurants}>
        Show Nearby Restaurants
      </button>
      
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error}</div>}
      
      {showRestaurants && restaurants.length > 0 && ( // Show restaurants only when the button is clicked
        <div>
          <h2>Nearby Restaurants</h2>
          <ul>
            {restaurants.map((restaurant) => (
              <li key={restaurant.place_id}>
                <h3>{restaurant.name}</h3>
                <p>{restaurant.vicinity}</p>
                <p>Rating: {restaurant.rating}</p>
              </li>
            ))}
          </ul>
          <button onClick={closeRestaurants}>Close</button> {/* Close button */}
        </div>
      )}
    </div>
  );
};

export default NearbyRestaurants;