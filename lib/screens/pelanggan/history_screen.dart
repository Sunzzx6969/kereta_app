import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/ticket_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Background abu-abu tipis biar card putih "pop out"
      appBar: AppBar(
        title: const Text("Riwayat Pemesanan", 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: -0.5)),
        centerTitle: true,
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. HEADER STATS (Design Lebih Berisi)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 35),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Total", "12"),
                  _vDivider(),
                  _buildStatItem("Aktif", "2"),
                  _vDivider(),
                  _buildStatItem("Selesai", "10"),
                ],
              ),
            ),
          ),

          // 2. LIST RIWAYAT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHeaderSection(Icons.confirmation_number_rounded, "Tiket Aktif"),
                _wrapTicket(
                  TicketCard(
                    code: "KAI-7721001",
                    date: "29 Januari 2026",
                    route: "Gambir (GMR) -> Pasar Turi (SBI)",
                  ),
                  "LUNAS", 
                  Colors.green,
                ),
                
                const SizedBox(height: 10),
                _buildHeaderSection(Icons.history_toggle_off_rounded, "Riwayat Perjalanan"),
                _wrapTicket(
                  TicketCard(
                    code: "KAI-8812902",
                    date: "15 Februari 2026",
                    route: "Yogyakarta (YK) -> Bandung (BD)",
                  ),
                  "SELESAI",
                  Colors.blueGrey,
                ),
                _wrapTicket(
                  TicketCard(
                    code: "KAI-9900123",
                    date: "10 Januari 2026",
                    route: "Semarang (SMT) -> Gambir (GMR)",
                  ),
                  "SELESAI",
                  Colors.blueGrey,
                ),
                
                const SizedBox(height: 30),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 15, top: 15),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryNavy),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  // Wrapper untuk menambah Badge Status di atas TicketCard
  Widget _wrapTicket(Widget card, String status, Color color) {
    return Stack(
      children: [
        card,
        Positioned(
          top: 25,
          right: 25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Text(status, 
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _vDivider() => Container(width: 1, height: 35, color: Colors.white.withOpacity(0.1));

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 15),
        Text("Sudah sampai di tujuan akhir", 
          style: TextStyle(color: Colors.blueGrey[300], fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Text("Terima kasih telah menggunakan layanan kami", 
          style: TextStyle(color: Colors.blueGrey[200], fontSize: 10)),
      ],
    );
  }
}