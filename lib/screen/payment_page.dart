import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screen/book_confirmation.dart';
import 'package:parking_app/screen/nav_bar.dart';

class PaymentPage extends StatefulWidget {
  final String mall;
  final String level;
  final String zone;

  const PaymentPage({
    super.key,
    required this.mall,
    required this.level,
    required this.zone,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'Debit Card'; // default

  final List<String> _paymentMethods = ['Debit Card', 'E-Wallet'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RM3.00 - 1 Hour Parking Fee',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),

            const Text(
              'Choose Payment Method:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Payment method options
            Column(
              children:
                  _paymentMethods.map((method) {
                    return RadioListTile<String>(
                      title: Text(method),
                      value: method,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            Center(
              child: Icon(
                _selectedPaymentMethod == 'Debit Card'
                    ? Icons.credit_card
                    : Icons.account_balance_wallet,
                size: 100,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User not logged in')),
                    );
                    return;
                  }

                  // Show loading spinner
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    await FirebaseFirestore.instance
                        .collection('userData')
                        .doc(user.uid)
                        .collection('bookings') //subcollectiom
                        .add({
                          'activeParking': {
                            'mall': widget.mall,
                            'level': widget.level,
                            'zone': widget.zone,
                            'startTime': Timestamp.now(),
                            'paymentMethod': _selectedPaymentMethod,
                          },
                        });

                    if (!context.mounted) return;

                    // Close loading spinner
                    Navigator.pop(context);

                    // Show success dialog
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (context) => AlertDialog(
                            title: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Payment Successful'),
                              ],
                            ),
                            content: Text(
                              'Your parking has been booked successfully using $_selectedPaymentMethod.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                    );

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => NavBarCategorySelectionScreen(
                              initialIndex: 1,
                              overridePage: BookingConfirmationPage(
                                mall: widget.mall,
                                level: widget.level,
                                zone: widget.zone,
                              ),
                            ),
                      ),
                    );
                  } catch (e) {
                    if (context.mounted)
                      Navigator.pop(context); // close spinner
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Payment failed: ${e.toString()}'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
