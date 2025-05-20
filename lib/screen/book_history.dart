import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Parking History'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          'Booking history will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
