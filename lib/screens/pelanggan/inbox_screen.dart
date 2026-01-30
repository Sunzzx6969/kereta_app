import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Kotak Masuk", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Tab Sederhana
          Container(
            color: AppColors.primaryNavy,
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                _buildFilterChip("Semua", true),
                const SizedBox(width: 10),
                _buildFilterChip("Transaksi", false),
                const SizedBox(width: 10),
                _buildFilterChip("Promo", false),
              ],
            ),
          ),

          // List Notifikasi
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildInboxTile(
                  title: "Pembayaran Berhasil!",
                  desc: "Tiket Argo Bromo Anggrek kamu sudah terbit. Cek e-tiket sekarang.",
                  time: "Baru saja",
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                  isUnread: true,
                ),
                _buildInboxTile(
                  title: "Promo Flash Sale!",
                  desc: "Diskon hingga 50% untuk rute Jakarta-Bandung khusus hari ini.",
                  time: "2 jam yang lalu",
                  icon: Icons.local_offer_rounded,
                  iconColor: AppColors.secondaryOrange,
                  isUnread: true,
                ),
                _buildInboxTile(
                  title: "Update Perjalanan",
                  desc: "Kereta Majapahit (801) tersedia di jalur 3 Stasiun Pasar Turi.",
                  time: "Kemarin",
                  icon: Icons.train_rounded,
                  iconColor: AppColors.primaryNavy,
                  isUnread: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondaryOrange : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildInboxTile({
    required String title,
    required String desc,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isUnread ? Border.all(color: AppColors.secondaryOrange.withOpacity(0.3)) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    if (isUnread)
                      const CircleAvatar(radius: 4, backgroundColor: Colors.red),
                  ],
                ),
                const SizedBox(height: 5),
                Text(desc, 
                  style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}