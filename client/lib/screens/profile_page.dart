import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${currentUser?.username ?? 'N/A'}'),
            const SizedBox(height: 10),
            Text('First Name: ${currentUser?.firstName ?? 'N/A'}'),
            const SizedBox(height: 10),
            Text('Last Name: ${currentUser?.lastName ?? 'N/A'}'),
            const SizedBox(height: 10),
            Text('Email: ${currentUser?.email ?? 'N/A'}'),
            const SizedBox(height: 10),
            Text('Phone Number: ${currentUser?.phoneNumber ?? 'N/A'}'),
            const SizedBox(height: 10),
            Text('Gender: ${currentUser?.gender ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}