// Details.jsx
import React, { useState } from 'react';
import axios from 'axios';

const Details = () => {
  const [restaurantDetails, setRestaurantDetails] = useState(null);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);
  const [isVisible, setIsVisible] = useState(false); // State to manage visibility

  const fetchRestaurantDetails = async () => {
    setLoading(true);
    setError(null); // Reset error state before fetching
    try {
      const response = await axios.get('http://localhost:3000/restaurant-details');
      setRestaurantDetails(response.data.result); // Get the restaurant details
      setIsVisible(true); // Set visibility to true when data is fetched
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const closeDetails = () => {
    setIsVisible(false); // Hide the details
    setRestaurantDetails(null); // Clear the restaurant details
  };

  return (
    <div>
      <button onClick={fetchRestaurantDetails}>
        Show Restaurant Details
      </button>
      
      {loading && <div>Loading...</div>}
      {error && <div>Error: {error}</div>}
      
      {isVisible && restaurantDetails && (
        <div>
          <h2>{restaurantDetails.name}</h2>
          <p>Address: {restaurantDetails.formatted_address}</p>
          <p>Rating: {restaurantDetails.rating}</p>
          <h3>Opening Hours:</h3>
          <ul>
            {restaurantDetails.opening_hours?.weekday_text.map((text, index) => (
              <li key={index}>{text}</li>
            ))}
          </ul>
          <h3>Reviews:</h3>
          <ul>
            {restaurantDetails.reviews.map((review) => (
              <li key={review.author_name}>
                <p><strong>{review.author_name}</strong> (Rating: {review.rating})</p>
                <p>{review.text}</p>
                <p>
                  <a href={review.author_url} target="_blank" rel="noopener noreferrer">
                    View Profile
                  </a>
                </p>
              </li>
            ))}
          </ul>
          <button onClick={closeDetails}>Close</button> {/* Close button */}
        </div>
      )}
    </div>
  );
};

export default Details;