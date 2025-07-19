import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminBookingList extends StatelessWidget {
  final String station;
  const AdminBookingList({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings – $station'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings') // top‑level bookings collection
            .where('station', isEqualTo: station) // match selected station
            // .orderBy('date', descending: true)  // add back ONLY when every doc has a valid date
            .snapshots(),
        builder: (context, snapshot) {
          // ---- loading / error guards ----
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Firestore error:\n${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text('No bookings found for this station.'),
            );
          }

          // ---- list of bookings ----
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              // ---------- VEHICLE ----------
              final vehicleField = data['vehicle'];
              String vehicleName = '';
              String vehicleNumber = '';
              String vehicleType = '';

              // vehicle may be stored as a Map OR as a plain String
              if (vehicleField is Map<String, dynamic>) {
                vehicleName = vehicleField['name'] ?? '';
                vehicleNumber = vehicleField['number'] ?? '';
                vehicleType = (vehicleField['type'] ?? '')
                    .toString()
                    .toUpperCase();
              } else if (vehicleField is String) {
                vehicleName = vehicleField;
              }

              // ---------- DATE ----------
              DateTime? date;
              final rawDate = data['date'];
              try {
                if (rawDate is Timestamp) {
                  date = rawDate.toDate();
                } else if (rawDate is String) {
                  date = DateTime.tryParse(rawDate);
                }
              } catch (_) {}
              final formattedDate = date != null
                  ? DateFormat.yMMMd().format(date)
                  : 'Unknown';

              // ---------- USER ----------
              final userId = data['userId'] ?? 'Unknown';

              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                              vehicleName.isNotEmpty
                                  ? vehicleName
                                  : 'Unknown Vehicle',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (vehicleNumber.isNotEmpty)
                              Text(
                                'Number: $vehicleNumber',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                            if (vehicleType.isNotEmpty)
                              Text(
                                'Type: $vehicleType',
                                style: const TextStyle(
                                  color: Colors.deepPurple,
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
                                  style: const TextStyle(color: Colors.black87),
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
    );
  }
}
