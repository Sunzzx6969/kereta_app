import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui'; // Wajib untuk efek kaca
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../providers/booking_provider.dart'; 
import 'booking_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String asal;
  final String tujuan;

  const SearchResultScreen({super.key, required this.asal, required this.tujuan});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<dynamic>> _futureJadwal;

  @override
  void initState() {
    super.initState();
    // --- MODIFIKASI: MATIKAN API, PAKSA KOSONG ---
    // Kita simulasi loading 2 detik, lalu return List Kosong []
    // Agar UI menampilkan pesan error/tidak ada data.
    _futureJadwal = Future.delayed(const Duration(seconds: 2), () => []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "${widget.asal} ➝ ${widget.tujuan}", 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            const Text("Hasil Pencarian", style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1330), // Darkest Navy
                    AppColors.primaryNavy,
                    Color(0xFF15264F),
                  ],
                ),
              ),
            ),
          ),
          
          // 2. GLOW EFFECT
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryOrange.withOpacity(0.15)),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container(color: Colors.transparent)),
            ),
          ),

          // 3. KONTEN
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: FutureBuilder<List<dynamic>>(
              future: _futureJadwal,
              builder: (context, snapshot) {
                // A. LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.secondaryOrange));
                }

                // B. DATA KOSONG (PASTI MASUK SINI SEKARANG)
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildGlassContainer(
                            padding: 30,
                            child: Icon(Icons.dns_rounded, size: 60, color: Colors.white.withOpacity(0.5)),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Maaf", 
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 22, fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 10),
                          // PESAN ERROR HANDLING
                          Text(
                            "Tidak ada respon data dari Server API",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.5, fontSize: 16),
                          ),
                          const SizedBox(height: 30),
                          
                          // Tombol Kembali
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.secondaryOrange),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: AppColors.secondaryOrange),
                              label: const Text("Kembali", style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold)),
                              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }

                // C. ADA DATA (TIDAK AKAN DIEKSEKUSI)
                final listKereta = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: listKereta.length,
                  itemBuilder: (context, index) {
                    final train = listKereta[index];
                    return _buildGlassTrainCard(train);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET KARTU KERETA (Disimpan buat jaga-jaga kalau mau dinyalakan lagi)
  Widget _buildGlassTrainCard(Map<String, dynamic> train) {
    // Code kartu tetap ada tapi tidak akan tampil
    return Container(); 
  }

  Widget _buildGlassContainer({required Widget child, double padding = 20}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}