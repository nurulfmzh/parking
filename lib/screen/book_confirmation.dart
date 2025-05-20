// booking_confirmation_page.dart
import 'package:flutter/material.dart';
import 'package:parking_app/screen/nav_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String mall;
  final String level;
  final String zone;

  const BookingConfirmationPage({
    super.key;
    required this.mall,
    required this.level,
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              'Booking Successful!',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 12),
            Text(
              'Mall: $mall\nLevel: $level\nZone: $zone',
              textAlign: TextAlign.center,
            ),

            QrImageView(
              data: 'Mall: $mall, Level: $level, Zone: $zone',
              size: 200,
            ),

            const SizedBox(height: 12),
            Text('Mall: $mall'),
            Text('Level: $level'),
            Text('Zone: $zone'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Return to main nav bar (default to home)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const NavBarCategorySelectionScreen(
                          initialIndex: 0,
                        ),
                  ),
                  (_) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
