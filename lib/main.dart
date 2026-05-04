import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LelempeunganApp());
}

class LelempeunganApp extends StatelessWidget {
  const LelempeunganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lelempeungan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3E2723), // Warna cokelat Sunda
      ),
      home: const HomeScreen(), // Pindahkan ke Home dulu sesuai Figma
    );
  }
}