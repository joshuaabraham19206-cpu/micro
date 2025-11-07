import 'package:flutter/material.dart';

// --- SCREEN 3: BOOKING ---
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book an Appointment', style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          // Fake counselor data
          final counselors = [
            {'name': 'Dr. Ananya Sharma', 'specialty': 'Anxiety & Stress Management'},
            {'name': 'Mr. Rohan Gupta', 'specialty': 'Career & Academic Counseling'},
            {'name': 'Dr. Priya Singh', 'specialty': 'Relationship Guidance'},
          ];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(counselors[index]['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(counselors[index]['specialty']!, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('View Availability'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
