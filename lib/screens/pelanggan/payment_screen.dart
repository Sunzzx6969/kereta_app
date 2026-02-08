import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../../utils/colors.dart';
import '../../providers/booking_provider.dart';
import 'ticket_detail_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const PaymentScreen({super.key, required this.bookingData});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String _method = "Transfer Bank";
  // FIX: Langsung inisialisasi agar tidak error LateInitialization
  final String _tanggalPembelian = DateFormat(
    'dd MMM yyyy, HH:mm',
  ).format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final item = widget.bookingData;
    final fmt = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    String total = fmt.format(
      int.tryParse((item['total_harga'] ?? item['harga'] ?? '0').toString()) ??
          0,
    );

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1330),
                    AppColors.primaryNavy,
                    Color(0xFF15264F),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rincian Transaksi",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _glassCard(
                    child: Column(
                      children: [
                        _row(
                          Icons.train,
                          "Kereta",
                          item['nama_kereta'] ?? 'Sriwijaya',
                        ),
                        const Divider(color: Colors.white10, height: 20),
                        _row(
                          Icons.calendar_today,
                          "Jadwal",
                          item['tanggal_berangkat'] ?? '2026-04-06 21:00:00',
                        ),
                        const Divider(color: Colors.white10, height: 20),
                        _row(
                          Icons.location_on,
                          "Rute",
                          "${item['asal'] ?? 'MALANG'} ➝ ${item['tujuan'] ?? 'JAKARTA'}",
                        ),
                        const Divider(color: Colors.white10, height: 20),
                        _row(
                          Icons.person,
                          "Penumpang",
                          item['nama_penumpang'] ?? 'User',
                        ),
                        const Divider(color: Colors.white10, height: 20),
                        _row(Icons.access_time, "Waktu", _tanggalPembelian),
                        const Divider(color: Colors.white24, height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Tagihan",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              total,
                              style: const TextStyle(
                                color: AppColors.secondaryOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Metode Pembayaran",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _payTile("Transfer Bank", Icons.account_balance),
                  _payTile("E-Wallet", Icons.account_balance_wallet),
                  _payTile("Retail Mart", Icons.storefront),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primaryNavy.withOpacity(0.9),
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _isProcessing
                      ? null
                      : () async {
                          setState(() => _isProcessing = true);
                          await Provider.of<BookingProvider>(
                            context,
                            listen: false,
                          ).bayarTiket(item['id_booking']);
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() => _isProcessing = false);
                          _showDone(item, total);
                        },
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "KONFIRMASI & BAYAR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDone(Map<String, dynamic> d, String h) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.secondaryOrange),
        ),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
            SizedBox(height: 10),
            Text("Berhasil!", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          "Pembayaran sukses. Cek tiket di riwayat.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryOrange,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (c) => TicketDetailScreen(
                        bookingData: {
                          ...d,
                          'status': 'lunas',
                          'metode_bayar': _method,
                          'tanggal_pembelian': _tanggalPembelian,
                        },
                        paymentMethod: _method,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "LIHAT E-TIKET",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIXED ROW: Agar simetris kanan-kiri
  Widget _row(IconData i, String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(i, color: AppColors.secondaryOrange, size: 18),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: Text(
            l,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
        const Text(" : ", style: TextStyle(color: Colors.white54)),
        Expanded(
          flex: 6,
          child: Text(
            v,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _glassCard({required Widget child}) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.white10),
    ),
    child: child,
  );
  Widget _payTile(String t, IconData i) {
    bool isS = _method == t;
    return InkWell(
      onTap: () => setState(() => _method = t),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isS
              ? AppColors.secondaryOrange.withOpacity(0.1)
              : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isS ? AppColors.secondaryOrange : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Icon(i, color: isS ? AppColors.secondaryOrange : Colors.white24),
            const SizedBox(width: 15),
            Text(
              t,
              style: TextStyle(
                color: isS ? Colors.white : Colors.white38,
                fontWeight: isS ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isS)
              const Icon(
                Icons.check_circle,
                color: AppColors.secondaryOrange,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
