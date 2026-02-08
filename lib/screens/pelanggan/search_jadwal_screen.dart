import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Wajib untuk Glassmorphism
import '../../utils/colors.dart';
import '../../providers/booking_provider.dart'; 
import 'search_result_screen.dart';

class SearchJadwalScreen extends StatefulWidget {
  const SearchJadwalScreen({super.key});

  @override
  _SearchJadwalScreenState createState() => _SearchJadwalScreenState();
}

class _SearchJadwalScreenState extends State<SearchJadwalScreen> {
  // List Stasiun Manual (Biar tidak Error Provider)
  List<String> stations = [
    "Gambir (GMR)",
    "Pasar Senen (PSE)",
    "Bandung (BD)",
    "Yogyakarta (YK)",
    "Solo Balapan (SLO)",
    "Semarang Tawang (SMT)",
    "Surabaya Gubeng (SGU)",
    "Surabaya Pasarturi (SBI)",
    "Malang (ML)",
    "Purwokerto (PWT)",
    "Cirebon (CN)"
  ]; 
  
  bool isLoadingStations = true;
  String? asal;
  String? tujuan;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // --- SIMULASI LOADING DATA ---
  Future<void> _initData() async {
    // Simulasi loading sebentar biar kerasa canggih
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        // Set Default Value
        asal = "Gambir (GMR)";
        tujuan = "Bandung (BD)";
        isLoadingStations = false;
      });
    }
  }

  // --- MODAL PILIH STASIUN ---
  void _showStationPicker(bool isAsal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B), // Background Navy Gelap
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAsal ? "Pilih Stasiun Asal" : "Pilih Stasiun Tujuan",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  itemCount: stations.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final stasiunName = stations[index];
                    return ListTile(
                      leading: Icon(Icons.train_rounded, color: isAsal ? Colors.blueAccent : Colors.redAccent),
                      title: Text(stasiunName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      onTap: () {
                        setState(() {
                          if (isAsal) {
                            asal = stasiunName;
                          } else {
                            tujuan = stasiunName;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _swapStations() {
    setState(() {
      String? temp = asal;
      asal = tujuan;
      tujuan = temp;
    });
  }

  void _handleSearch() {
    if (isLoadingStations) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sedang memuat data...")));
       return;
    }
    if (asal == null || tujuan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih stasiun terlebih dahulu")));
      return;
    }
    
    // Kirim Data Pilihan ke Halaman Hasil
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          asal: asal!,
          tujuan: tujuan!,
        ),
      ),
    );
  }

  // --- UI GLASSMORPHISM ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      appBar: AppBar(
        title: const Text("Cari Tiket", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT & GLOW
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1330), AppColors.primaryNavy, Color(0xFF15264F)],
                ),
              ),
            ),
          ),
          Positioned(
            top: -50, right: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondaryOrange.withOpacity(0.15)),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container(color: Colors.transparent)),
            ),
          ),

          // 2. KONTEN
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(Icons.map_rounded, size: 60, color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 10),
                const Text(
                  "Mau pergi ke mana?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  "Pilih rute perjalanan Anda",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                
                const SizedBox(height: 40),

                // CARD GLASS (PENCARIAN)
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: isLoadingStations 
                        ? const Center(child: CircularProgressIndicator(color: AppColors.secondaryOrange))
                        : Column(
                          children: [
                            // INPUT ASAL
                            _buildInputTile("Stasiun Asal", asal ?? "Pilih...", Icons.my_location, Colors.blueAccent, () => _showStationPicker(true)),
                            
                            // SWAP BUTTON
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: InkWell(
                                onTap: _swapStations,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryOrange.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.secondaryOrange)
                                  ),
                                  child: const Icon(Icons.swap_vert, color: AppColors.secondaryOrange),
                                ),
                              ),
                            ),

                            // INPUT TUJUAN
                            _buildInputTile("Stasiun Tujuan", tujuan ?? "Pilih...", Icons.location_on, Colors.redAccent, () => _showStationPicker(false)),

                            const SizedBox(height: 40),

                            // TOMBOL CARI
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(colors: [AppColors.secondaryOrange, Color(0xFFFF6B00)]),
                                boxShadow: [BoxShadow(color: AppColors.secondaryOrange.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: _handleSearch,
                                child: const Text("CARI JADWAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTile(String label, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08), // Transparan gelap
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}