import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingHistory extends StatelessWidget {
  const BookingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe3f0fd), Color(0xFFb6e0fe), Color(0xFFe0c3fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print('Firestore Error: ${snapshot.error}');
              return Center(
                child: Text("Something went wrong:\n${snapshot.error}"),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No bookings found."));
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                late DateTime date;
                final rawDate = booking['date'];
                try {
                  if (rawDate is Timestamp) {
                    date = rawDate.toDate();
                  } else if (rawDate is String) {
                    date = DateTime.parse(rawDate);
                  } else {
                    return const ListTile(title: Text("Invalid date format"));
                  }
                } catch (_) {
                  return const ListTile(title: Text("Date parse error"));
                }

                final formattedDate = DateFormat.yMMMd().format(date);

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 18,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.directions_car,
                            color: Colors.blueAccent,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['vehicle'] != null &&
                                        booking['vehicle'] is String
                                    ? booking['vehicle']
                                    : booking['vehicle'] is Map
                                    ? (booking['vehicle']['name'] ?? '')
                                          .toString()
                                    : '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking['station'] != null &&
                                        booking['station'] is String
                                    ? booking['station']
                                    : booking['station'] is Map
                                    ? (booking['station']['name'] ?? '')
                                          .toString()
                                    : '',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    userId,
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
