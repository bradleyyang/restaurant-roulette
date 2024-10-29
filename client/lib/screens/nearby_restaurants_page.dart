import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'restaurant_details_page.dart';
import '../api_utils.dart';

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
    final String apiUrl = '${getBaseUrl()}/nearby-restaurants';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          restaurants = data['results'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
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
                    final isOpen =
                        restaurant['opening_hours']?['open_now'] ?? false;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.circle,
                          color: isOpen ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        title: Text(restaurant['name']),
                        subtitle: Text(restaurant['vicinity']),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              restaurant['rating'] != null
                                  ? restaurant['rating'].toString()
                                  : 'N/A',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              isOpen ? 'Open' : 'Closed',
                              style: TextStyle(
                                color: isOpen ? Colors.green : Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => openRestaurantDetails(restaurant['name']),
                      ),
                    );
                  },
                ),
    );
  }
}
