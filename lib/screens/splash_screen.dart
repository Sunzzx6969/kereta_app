import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Berpindah ke login setelah 3 detik
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna latar yang lebih halus (tidak kaku) agar logo menonjol
      backgroundColor: Color(0xFFF5F7F9), 
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menggunakan Logo Identitas Baru: PEKERTA.IND
                Hero(
                  tag: 'logo_utama',
                  child: Image.asset(
                    'assets/images/PEKERTA_TRANSPARANT.png', // Pastikan path asset sesuai
                    width: 250, 
                  ),
                ),
                SizedBox(height: 40),
                // Indikator loading yang lebih halus (Navy transparan)
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1).withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ),
          // Footer kecil di bagian bawah (Opsional)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Versi 1.0.0",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}