// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
       apiKey: "AIzaSyBflJLHo7G20W3kkesyARlCMPMybNU9YV8",
  authDomain: "vehiclestationproject.firebaseapp.com",
  projectId: "vehiclestationproject",
  storageBucket: "vehiclestationproject.firebasestorage.app",
  messagingSenderId: "252828536665",
  appId: "1:252828536665:web:21efe34fad4aa91d45c648",
    ),

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Service Station',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
      
    );
  }
}
