import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
// no glassmorphic import needed

class BookService extends StatefulWidget {
  const BookService({super.key});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  String? selectedVehicle;
  String? selectedStation;
  DateTime? selectedDate;

  final List<String> vehicles = ['Car', 'Bike', 'Truck'];
  final List<String> stations = ['Mangalore', 'Surathkal', 'Udupi'];

  final TextEditingController dateController = TextEditingController();

  void _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _bookService() async {
    if (selectedVehicle == null ||
        selectedStation == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': user.uid,
      'vehicle': selectedVehicle,
      'station': selectedStation,
      'date': selectedDate!.toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service booked successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book a Service"),
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
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.build, size: 54, color: Colors.blueAccent),
                  const SizedBox(height: 12),
                  const Text(
                    "Book a Service",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Fill the details below to book your service",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  DropdownButtonFormField<String>(
                    value: selectedVehicle,
                    hint: const Text("Select Vehicle"),
                    items: vehicles
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedVehicle = v),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.directions_car,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.blue[50],
                      labelText: 'Vehicle',
                      labelStyle: const TextStyle(color: Colors.blueAccent),
                    ),
                    dropdownColor: Colors.blue[50],
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    value: selectedStation,
                    hint: const Text("Select Station"),
                    items: stations
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (s) => setState(() => selectedStation = s),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: Colors.deepPurple,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.purple[50],
                      labelText: 'Station',
                      labelStyle: const TextStyle(color: Colors.deepPurple),
                    ),
                    dropdownColor: Colors.purple[50],
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Select Date",
                      labelStyle: const TextStyle(color: Colors.teal),
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.teal,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.teal[50],
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _bookService,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        "Book Service",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 207, 210, 215),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
