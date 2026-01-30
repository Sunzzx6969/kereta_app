import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    // Menangkap argumen kursi yang dipilih sebelumnya
    final Map? seatArgs = ModalRoute.of(context)?.settings.arguments as Map?;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. RINGKASAN TAGIHAN (Card Atas)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const Text("Total Pembayaran", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  "Rp 500.000",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondaryOrange,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "Kursi ${seatArgs?['nama_kursi'] ?? '1A'}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // 2. DAFTAR METODE PEMBAYARAN
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              children: [
                const Text(
                  "Metode Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 20),
                _methodTile(0, "Transfer Bank (VA)", Icons.account_balance_rounded, "BCA, Mandiri, BNI"),
                _methodTile(1, "E-Wallet", Icons.account_balance_wallet_rounded, "OVO, GoPay, Dana"),
                _methodTile(2, "Gerai Retail", Icons.storefront_rounded, "Alfamart, Indomaret"),
                
                const SizedBox(height: 20),
                // Security Note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 5),
                    Text("Secure 256-bit SSL encrypted payment", 
                      style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          // 3. TOMBOL BAYAR (Bottom Fixed)
          Container(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: CustomButton(
              text: "BAYAR SEKARANG",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/ticket-detail',
                  arguments: {
                    'nama': 'Hana', // Data Dummy sesuai instruksi
                    'kursi': seatArgs?['nama_kursi'] ?? '1A',
                    'kereta': 'Argo Bromo Anggrek'
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodTile(int index, String title, IconData icon, String subtitle) {
    bool isSelected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryNavy : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primaryNavy.withOpacity(0.1) : Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryNavy : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : AppColors.primaryNavy, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            Radio(
              value: index,
              groupValue: _selectedMethod,
              activeColor: AppColors.primaryNavy,
              onChanged: (int? value) => setState(() => _selectedMethod = value!),
            ),
          ],
        ),
      ),
    );
  }
}