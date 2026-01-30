import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';

class TicketDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // PROTEKSI: Mengambil data arguments dengan aman
    final Map args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {
      'nama': 'Penumpang',
      'kursi': '-',
      'kereta': 'Kereta Api Express'
    };

    return Scaffold(
      backgroundColor: AppColors.primaryNavy, // Background navy agar tiket putih terlihat kontras
      appBar: AppBar(
        title: const Text("E-Tiket Resmi", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
        child: Column(
          children: [
            // KONTEN TIKET UTAMA
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  // BAGIAN ATAS TIKET
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(args['kereta'], 
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryNavy)),
                                const Text("Eksekutif Class", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            Icon(Icons.train_rounded, color: AppColors.secondaryOrange, size: 30),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        // QR CODE
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Icon(Icons.qr_code_2_rounded, size: 180, color: AppColors.primaryNavy),
                        ),
                        const SizedBox(height: 10),
                        const Text("Tunjukkan QR Code ini ke petugas stasiun", 
                          style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),

                  // GARIS SOBEKAN TIKET (Punched Holes effect)
                  Row(
                    children: [
                      SizedBox(height: 20, width: 10, child: DecoratedBox(decoration: BoxDecoration(color: AppColors.primaryNavy, borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))))),
                      Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: LayoutBuilder(builder: (context, constraints) {
                        return Flex(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate((constraints.constrainWidth() / 10).floor(), (index) => SizedBox(width: 5, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey[300])))));
                      }))),
                      SizedBox(height: 20, width: 10, child: DecoratedBox(decoration: BoxDecoration(color: AppColors.primaryNavy, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))))),
                    ],
                  ),

                  // BAGIAN BAWAH TIKET (Detail Penumpang)
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        _rowInfo("Nama Penumpang", args['nama']),
                        _rowInfo("Nomor Kursi", args['kursi']),
                        _rowInfo("Tanggal", "29 Jan 2026"),
                        _rowInfo("Waktu", "08:00 WIB"),
                        const Divider(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Text("PEMBAYARAN LUNAS", 
                              style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 35),
            
            // TOMBOL AKSI
            CustomButton(
              text: "SIMPAN TIKET (PDF)",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tiket berhasil disimpan ke Galeri!"), behavior: SnackBarBehavior.floating)
                );
              },
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
              child: const Text("Kembali ke Beranda", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}