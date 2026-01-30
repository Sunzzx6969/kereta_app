import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';

class DetailJadwalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menangkap data dinamis dari HomeContent
    final Map args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final String namaKereta = args['nama'] ?? 'KAI Express';
    final String hargaStr = args['harga'] ?? '0';
    final int harga = int.tryParse(hargaStr) ?? 0;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // HEADER PREMIUM COLLAPSIBLE
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: AppColors.primaryNavy,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, Color(0xFF0D1B3E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.train_rounded, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(namaKereta, 
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    const Text("Eksekutif Class", 
                      style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ),

          // KONTEN DETAIL UTAMA
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rute Perjalanan", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryNavy)),
                  const SizedBox(height: 35),
                  
                  // KEBERANGKATAN
                  _buildTimelineTile(
                    time: "08:00",
                    station: "Stasiun Gambir (GMR)",
                    isFirst: true,
                  ),
                  
                  // CONNECTOR (GARIS PEMISAH LEGA)
                  _buildRouteConnector(), 

                  // KEDATANGAN
                  _buildTimelineTile(
                    time: "16:00",
                    station: "Stasiun Pasar Turi (SBI)",
                    isLast: true,
                  ),
                  
                  const SizedBox(height: 20),
                  Divider(height: 60, color: Colors.grey[100], thickness: 1.5),
                  
                  // INFO TAMBAHAN
                  _infoRow(Icons.timer_outlined, "Durasi", "8 Jam 0 Menit"),
                  _infoRow(Icons.event_seat_outlined, "Fasilitas", "AC, Port Charger, Makan"),
                  
                  const SizedBox(height: 35),
                  
                  // HARGA BOX
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Harga Tiket", 
                          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                        Text(AppHelpers.formatRupiah(harga), 
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.secondaryOrange)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TOMBOL FIX DI BAWAH
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: "LANJUT PILIH KURSI",
                    onPressed: () => Navigator.pushNamed(context, '/booking', arguments: {'nama': namaKereta}),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRouteConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 60, // JARAK LEGA ANTAR RUTE
        width: 2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryOrange, AppColors.primaryNavy],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineTile({required String time, required String station, bool isFirst = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: isFirst ? AppColors.secondaryOrange : AppColors.primaryNavy,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isFirst ? AppColors.secondaryOrange : AppColors.primaryNavy).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 4),
              Text(station, style: TextStyle(color: Colors.blueGrey[600], fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        )
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey[300]),
          const SizedBox(width: 15),
          Text("$label: ", style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
        ],
      ),
    );
  }
}