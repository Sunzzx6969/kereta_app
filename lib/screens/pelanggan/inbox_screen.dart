import 'package:flutter/material.dart';
import 'dart:ui'; 
import '../../utils/colors.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy untuk Inbox
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Perubahan Jadwal Kereta",
        "body": "Mohon perhatikan perubahan jadwal keberangkatan untuk rute Jakarta - Surabaya per tanggal 1 Maret 2026.",
        "time": "Kemarin",
        "icon": Icons.access_time_filled,
        "color": Colors.blueAccent,
        "isRead": true,
      },
      {
        "title": "Selamat Datang di Pekerta App!",
        "body": "Akun Anda berhasil dibuat. Lengkapi profil Anda untuk kemudahan pemesanan tiket selanjutnya.",
        "time": "2 Hari yang lalu",
        "icon": Icons.account_circle,
        "color": Colors.purpleAccent,
        "isRead": true,
      },
       {
        "title": "Maintenance Sistem",
        "body": "Kami akan melakukan pemeliharaan sistem pada pukul 00:00 - 02:00 WIB. Mohon maaf atas ketidaknyamanan ini.",
        "time": "3 Hari yang lalu",
        "icon": Icons.settings,
        "color": Colors.grey,
        "isRead": true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Kotak Masuk", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          // Background Gradient Konsisten
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

          // Glow Efek (Opsional, biar cantik)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withOpacity(0.1)),
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), child: Container(color: Colors.transparent)),
            ),
          ),

          // List Notifikasi
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              return _buildNotificationCard(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    bool isRead = item['isRead'];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // Kalau belum dibaca, background agak lebih terang
              color: isRead ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isRead ? Colors.white.withOpacity(0.1) : AppColors.secondaryOrange.withOpacity(0.3),
                width: 1
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Bulat
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 24),
                ),
                const SizedBox(width: 15),
                
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'], 
                              style: TextStyle(
                                fontWeight: isRead ? FontWeight.w600 : FontWeight.bold, 
                                fontSize: 16, 
                                color: Colors.white
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Indikator Belum Baca (Titik Merah)
                          if (!isRead)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: 8, height: 8,
                              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['body'], 
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, height: 1.3),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['time'], 
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}