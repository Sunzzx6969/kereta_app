import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:intl/intl.dart';

class DetailJadwalScreen extends StatelessWidget {
  const DetailJadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map item = ModalRoute.of(context)!.settings.arguments as Map;

    // Helper format jam
    String parseJam(String? dt) {
      if(dt == null) return "--:--";
      try { return DateFormat('HH:mm').format(DateTime.parse(dt)); } catch(e) { return "--:--"; }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Detail Perjalanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryNavy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
            color: AppColors.primaryNavy,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stationInfo(item['asal_keberangkatan'] ?? "Asal", parseJam(item['tanggal_berangkat'])),
                const Icon(Icons.arrow_right_alt, color: AppColors.secondaryOrange, size: 40),
                _stationInfo(item['tujuan_keberangkatan'] ?? "Tujuan", parseJam(item['tanggal_kedatangan'])),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text("KAI Express - Eksekutif"),
                   const SizedBox(height: 10),
                   Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                      .format(int.tryParse(item['harga'].toString()) ?? 0),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondaryOrange),
                   ),
                 ],
               ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
                onPressed: () {
                  // Kirim data jadwal ke BookingScreen
                  Navigator.pushNamed(context, '/booking', arguments: item);
                },
                child: const Text("PILIH KURSI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _stationInfo(String city, String time) {
    return Column(
      children: [
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        Text(city.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}