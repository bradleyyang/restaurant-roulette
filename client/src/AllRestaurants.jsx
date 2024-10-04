import React, { useEffect, useState } from 'react';
import axios from 'axios';

const AllRestaurants = () => {
    const [restaurants, setRestaurants] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        // Fetch the list of restaurants from the backend
        const fetchRestaurants = async () => {
            try {
                const response = await axios.get('http://localhost:3000/restaurants'); // Update with your backend URL
                console.log('Fetched restaurants:', response.data);
                setRestaurants(response.data); // Set the fetched data to state
                setLoading(false); // Set loading to false after data is fetched
            } catch (err) {
                console.error('Error fetching restaurants:', err);
                setError('Failed to fetch restaurants');
                setLoading(false);
            }
        };

        fetchRestaurants();
    }, []); // Empty dependency array means this runs once when the component mounts

    if (loading) return <div>Loading...</div>;
    if (error) return <div>{error}</div>;

    return (
        <div>
            <h1>Restaurants List</h1>
            <ul>
                {restaurants.slice(0, 10).map((restaurant) => (
                    <li key={restaurant._id}>
                        <h2>{restaurant.name}</h2>
                        <p>Address: {restaurant.formatted_address}</p>
                        <p>Rating: {restaurant.rating}</p>
                        <p>Distance: {restaurant.distance} km</p>
                        <p>Price Level: {restaurant.price_level}</p>
                        <p>Total Ratings: {restaurant.user_ratings_total}</p>
                        <p>{restaurant.open_now ? "Open Now" : "Closed"}</p>
                    </li>
                ))}
            </ul>
        </div>
    );

}

export default AllRestaurants;