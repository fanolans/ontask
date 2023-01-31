import 'package:flutter/material.dart';

class LocationHomeScreen extends StatefulWidget {
  const LocationHomeScreen({super.key});

  @override
  State<LocationHomeScreen> createState() => _LocationHomeScreenState();
}

class _LocationHomeScreenState extends State<LocationHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Get location'),
          ),
        ],
      ),
    );
  }
}
