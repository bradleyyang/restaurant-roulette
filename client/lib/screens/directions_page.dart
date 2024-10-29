import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectionsPage extends StatefulWidget {
  final String restaurantName;
  final String restaurantAddress;

  DirectionsPage({
    required this.restaurantName,
    required this.restaurantAddress,
  });

  @override
  _DirectionsPageState createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  String _errorMessage = '';
  String? _userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    // Hardcoded user location for testing (latitude and longitude)
    const double hardcodedLatitude = 43.472286; // Latitude for UW
    const double hardcodedLongitude = -80.544861; // Longitude for UW

    // Simulate getting location
    setState(() {
      _userLocation = '$hardcodedLatitude,$hardcodedLongitude';
    });
  }

  void _launchMapsURL() async {
    if (_userLocation != null) {
      // Clean up the address to remove any unit numbers and trailing spaces
      String cleanAddress = _removeUnitNumber(widget.restaurantAddress).trim();
      final encodedDestination = Uri.encodeComponent(cleanAddress);

      final String directionsUrl =
          'https://www.google.com/maps/dir/?api=1&origin=$_userLocation&destination=$encodedDestination';

      // Log for debugging
      print('Original Address: ${widget.restaurantAddress}');
      print('Cleaned Address: $cleanAddress');
      print('Generated URL: $directionsUrl');

      try {
        await launchUrl(Uri.parse(directionsUrl),
            mode: LaunchMode.externalApplication);
      } catch (e) {
        setState(() {
          _errorMessage = 'Could not open Google Maps: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'User location not available';
      });
    }
  }

  // Helper function to remove unit numbers and extra characters
  String _removeUnitNumber(String address) {
    // Use regex to remove unit indicators like #, Unit, and Suite
    final RegExp unitPattern =
        RegExp(r'(?:#\d+|Unit\s*\w+|Suite\s*\w+)', caseSensitive: false);
    return address.replaceAll(unitPattern, '').replaceAll(RegExp(r'\s+'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions to ${widget.restaurantName}'),
      ),
      body: Center(
        child: _errorMessage.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Get directions to ${widget.restaurantName}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _launchMapsURL,
                    child: Text('Get Directions'),
                  ),
                ],
              ),
      ),
    );
  }
}
