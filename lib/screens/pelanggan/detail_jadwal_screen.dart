import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';

class DetailJadwalScreen extends StatefulWidget {
  @override
  _DetailJadwalScreenState createState() => _DetailJadwalScreenState();
}

class _DetailJadwalScreenState extends State<DetailJadwalScreen> {
  // Gatekeeper screen: Menampilkan detail sebelum pemilihan kursi real-time
  
  @override
  Widget build(BuildContext context) {
    // Menangkap data jadwal dari Navigator (dikirim dari Home)
    final Map item = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Detail Perjalanan", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. HEADER INFO RUTE (Navy Background)
          _buildTripHeader(item),

          const SizedBox(height: 25),

          // 2. KARTU RINGKASAN KERETA & FASILITAS
          _buildFacilityCard(item),

          const SizedBox(height: 20),

          // 3. DETAIL TAMBAHAN (Waktu Perjalanan, Kelas, dll)
          _buildDetailList(item),

          const Spacer(),

          // 4. VISUAL REMINDER
          const Icon(Icons.info_outline_rounded, size: 40, color: Colors.black12),
          const SizedBox(height: 10),
          const Text(
            "Pastikan waktu keberangkatan sudah sesuai.\nKursi akan dipilih pada langkah berikutnya.", 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.5)
          ),

          const Spacer(),

          // 5. BOTTOM ACTION (Lanjut ke BookingScreen)
          _buildBottomAction(item),
        ],
      ),
    );
  }

  Widget _buildTripHeader(Map item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stationInfo(item['stasiun_asal'] ?? "Origin", item['waktu_berangkat'] ?? "--:--"),
          Column(
            children: [
              Icon(Icons.arrow_right_alt, color: AppColors.secondaryOrange, size: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Text("Eksekutif", style: TextStyle(color: Colors.white70, fontSize: 10)),
              ),
            ],
          ),
          _stationInfo(item['stasiun_tujuan'] ?? "Dest", item['waktu_tiba'] ?? "--:--"),
        ],
      ),
    );
  }

  Widget _stationInfo(String city, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(city.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.1)),
      ],
    );
  }

  Widget _buildFacilityCard(Map item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy.withValues(alpha: 0.1), 
              borderRadius: BorderRadius.circular(15)
            ),
            child: Icon(Icons.train_rounded, color: AppColors.primaryNavy, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['nama_kereta'] ?? "KAI Express", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2D3436))),
                const SizedBox(height: 4),
                const Text("AC • Power Outlet • Meals Service", 
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailList(Map item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _detailRow(Icons.calendar_today, "Tanggal", "30 Jan 2026"), // Bisa ambil dari item jika ada
          const Divider(height: 30),
          _detailRow(Icons.timer_outlined, "Durasi", "± 3 Jam 15 Menit"),
          const Divider(height: 30),
          _detailRow(Icons.confirmation_number_outlined, "Sisa Kursi", "42 Kursi Tersedia"),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 15),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildBottomAction(Map item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Harga Per Orang", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  AppHelpers.formatRupiah(int.tryParse(item['harga'].toString()) ?? 0),
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppColors.secondaryOrange),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // PINDAH KE BOOKING SCREEN (Sesuai alur: Pilih Kursi & Gerbong)
              Navigator.pushNamed(context, '/booking', arguments: item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            child: const Text("PILIH KURSI", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
          )
        ],
      ),
    );
  }
}