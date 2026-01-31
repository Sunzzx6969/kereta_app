import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../providers/admin_provider.dart'; // Import Provider Sultan

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'gopay'; // Default method

  @override
  Widget build(BuildContext context) {
    // Menangkap data dari BookingScreen
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    final Map jadwal = args['jadwal'];
    final Map kursi = args['kursi'];
    final int totalHarga = args['total_harga'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Pembayaran", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryNavy,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. RINGKASAN TIKET
            _buildOrderSummary(jadwal, kursi),
            const SizedBox(height: 25),

            // 2. PILIH METODE PEMBAYARAN
            const Text("Metode Pembayaran", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            _buildPaymentMethod("GOPAY", Icons.account_balance_wallet, "gopay"),
            _buildPaymentMethod("OVO", Icons.account_balance_wallet_outlined, "ovo"),
            _buildPaymentMethod("Transfer Bank (VA)", Icons.account_balance, "bank"),

            const SizedBox(height: 25),

            // 3. RINCIAN HARGA
            _buildPriceDetail(totalHarga),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(totalHarga, jadwal, kursi),
    );
  }

  Widget _buildOrderSummary(Map jadwal, Map kursi) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.train, color: AppColors.primaryNavy),
              const SizedBox(width: 10),
              Text(jadwal['nama_kereta'] ?? "Kereta", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Stasiun", "${jadwal['stasiun_asal']} → ${jadwal['stasiun_tujuan']}"),
              _infoTile("Kursi", "G${kursi['gerbong_pilihan']} - ${kursi['seat_label']}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildPaymentMethod(String title, IconData icon, String value) {
    bool isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.secondaryOrange : Colors.grey[200]!, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryNavy), 
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.secondaryOrange)
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetail(int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _priceRow("Harga Tiket", total),
          _priceRow("Biaya Layanan", 2000),
          const Divider(height: 20),
          _priceRow("Total Pembayaran", total + 2000, isTotal: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(AppHelpers.formatRupiah(amount), 
            style: TextStyle(fontWeight: FontWeight.bold, color: isTotal ? AppColors.secondaryOrange : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(int total, Map jadwal, Map kursi) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: CustomButton(
        text: "BAYAR SEKARANG",
        onPressed: () async {
          // LOADING DIALOG
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

          try {
            final adminProv = Provider.of<AdminProvider>(context, listen: false);

            // UPDATE STATUS KURSI DI DATABASE
            await adminProv.updateKursiStatus(
              kursi['id_kursi'].toString(), 
              '0'
            );

            // TUTUP LOADING
            if (mounted) Navigator.pop(context);

            // NAVIGASI KE TIKET DETAIL
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
  context, 
  '/ticket_detail', // Harus persis sama dengan yang ada di main.dart
  (route) => false, 
  arguments: {
    'jadwal': jadwal,
    'kursi': kursi,
    'metode': selectedMethod,
    'tanggal_bayar': DateTime.now().toString(),
  },
);
            }
          } catch (e) {
            if (mounted) Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
            );
          }
        },
      ),
    );
  }
}