import 'package:flutter/material.dart';
import '../booking/admin_booking_list.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  void navigateToStation(BuildContext context, String station) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminBookingList(station: station)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stations = [
      {
        'name': 'Mangalore',
        'icon': Icons.location_city,
        'color': Colors.blueAccent,
      },
      {
        'name': 'Surathkal',
        'icon': Icons.location_on,
        'color': Colors.deepPurple,
      },
      {'name': 'Udupi', 'icon': Icons.place, 'color': Colors.green},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.admin_panel_settings,
              size: 60,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              "Admin Panel",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Manage Bookings",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: stations.length,
                separatorBuilder: (context, i) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final s = stations[i];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (s['color'] as Color).withOpacity(
                          0.15,
                        ),
                        child: Icon(
                          s['icon'] as IconData,
                          color: s['color'] as Color,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        s['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                      onTap: () =>
                          navigateToStation(context, s['name'] as String),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
