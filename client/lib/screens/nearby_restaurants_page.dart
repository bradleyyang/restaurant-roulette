import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'restaurant_details_page.dart';

class NearbyRestaurantsPage extends StatefulWidget {
  @override
  _NearbyRestaurantsPageState createState() => _NearbyRestaurantsPageState();
}

class _NearbyRestaurantsPageState extends State<NearbyRestaurantsPage> {
  List<dynamic> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNearbyRestaurants();
  }

  Future<void> fetchNearbyRestaurants() async {
    const String apiUrl =
        'http://10.0.2.2:3000/nearby-restaurants'; // Your API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          restaurants =
              data['results']; // Get the 'results' array from the response
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  void openRestaurantDetails(String placeName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantDetailsPage(placeName: placeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : restaurants.isEmpty
              ? const Center(child: Text('No nearby restaurants found.'))
              : ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(restaurant['name']),
                        subtitle: Text(restaurant['vicinity']),
                        trailing: Text(
                          restaurant['rating'] != null
                              ? restaurant['rating'].toString()
                              : 'N/A',
                        ),
                        onTap: () => openRestaurantDetails(restaurant['name']),
                      ),
                    );
                  },
                ),
    );
  }
}
