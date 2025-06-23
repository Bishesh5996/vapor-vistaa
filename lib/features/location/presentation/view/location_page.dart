import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Location Page'),
      ),
    );
  }
} 