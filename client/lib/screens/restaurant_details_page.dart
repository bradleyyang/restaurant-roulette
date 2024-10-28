import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_utils.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String placeName;

  const RestaurantDetailsPage({Key? key, required this.placeName})
      : super(key: key);

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  Map<String, dynamic>? restaurantDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRestaurantDetails();
  }

  Future<void> fetchRestaurantDetails() async {
    final apiUrl =
        '${getBaseUrl()}/restaurant-details?place_name=${Uri.encodeComponent(widget.placeName)}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          restaurantDetails = json.decode(response.body)['result'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching restaurant details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : restaurantDetails == null
              ? Center(child: Text("Restaurant details not available."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantDetails?['name'] ?? 'N/A',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        restaurantDetails?['formatted_address'] ?? 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rating: ${restaurantDetails?['rating'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      if (restaurantDetails?['opening_hours'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Opening Hours:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ...List<Widget>.from(
                              (restaurantDetails?['opening_hours']
                                          ['weekday_text'] ??
                                      [])
                                  .map((day) => Text(day))
                                  .toList(),
                            ),
                          ],
                        ),
                      SizedBox(height: 16),
                      if (restaurantDetails?['reviews'] != null)
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                restaurantDetails?['reviews']?.length ?? 0,
                            itemBuilder: (context, index) {
                              final review =
                                  restaurantDetails?['reviews'][index];
                              return ListTile(
                                title:
                                    Text(review['author_name'] ?? 'Anonymous'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['text'] ?? '',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Rating: ${review['rating'] ?? 'N/A'} - ${review['relative_time_description'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
