import 'package:flutter/material.dart';
import 'bencana_page.dart'; 

void main() {
  runApp(const MyApp());
}

// Variabel tema Hitam-Merah
final ThemeData darkRedTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColor: const Color(0xFFB71C1C),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFB71C1C),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1C1C1C),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFB71C1C)),
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(5),
    ),
    labelStyle: const TextStyle(color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB71C1C),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFB71C1C),
    foregroundColor: Colors.white,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Bencana Alam',
      debugShowCheckedModeBanner: false,
      theme: darkRedTheme, 
      
      // Mengarahkan langsung ke halaman daftar bencana
      home: const BencanaPage(), 
    );
  }
}