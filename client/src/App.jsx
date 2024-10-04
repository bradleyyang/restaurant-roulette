import RestaurantDetails from "./RestaurantDetails";
import AllRestaurants from "./AllRestaurants";
import NearbyRestaurants from "./NearbyRestaurants";
import Details from "./Details";

const App = () => {

  return (
    <>
      <h1>All Restaurants List</h1>
      <AllRestaurants />
      <h1>Details for one restaurant</h1>
      <RestaurantDetails />
      <h1>Nearby Restaurants</h1>
      <NearbyRestaurants />
      <h1>Details</h1>
      <Details />
    </>
  )
};

export default App;