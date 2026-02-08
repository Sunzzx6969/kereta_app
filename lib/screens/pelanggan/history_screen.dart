import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';
import 'ticket_detail_screen.dart';
import 'payment_screen.dart'; // Wajib import ini Bos!

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Safety call agar tidak error merah saat pertama buka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final u = Provider.of<AuthProvider>(context, listen: false).user;
      if (u != null) Provider.of<BookingProvider>(context, listen: false).getHistory(u.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookingProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent, // Background tembus gradasi Sultan
      body: prov.isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.secondaryOrange))
        : prov.listHistory.isEmpty 
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 100), 
              itemCount: prov.listHistory.length, 
              itemBuilder: (context, i) {
                final item = prov.listHistory[i];
                // Logika Cek Status: mendukung 'lunas' atau '1'
                bool isLunas = item['status'].toString().toLowerCase() == 'lunas' || item['status'].toString() == '1';

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          onTap: () {
                            if (isLunas) {
                              // JIKA LUNAS -> KE E-TIKET
                              Navigator.push(context, MaterialPageRoute(
                                builder: (c) => TicketDetailScreen(
                                  bookingData: item, 
                                  paymentMethod: item['metode_bayar'] ?? "Online"
                                )
                              ));
                            } else {
                              // JIKA PENDING -> BALIK KE PEMBAYARAN
                              Navigator.push(context, MaterialPageRoute(
                                builder: (c) => PaymentScreen(
                                  bookingData: item, // Bawa data lama buat bayar ulang
                                )
                              ));
                            }
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isLunas ? Colors.green.withOpacity(0.1) : AppColors.secondaryOrange.withOpacity(0.1),
                              shape: BoxShape.circle
                            ),
                            child: Icon(
                              isLunas ? Icons.confirmation_number : Icons.payment, 
                              color: isLunas ? Colors.greenAccent : AppColors.secondaryOrange,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            item['nama_kereta'] ?? 'Sriwijaya', 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                          subtitle: Text(
                            "${item['asal'] ?? 'MALANG'} ➝ ${item['tujuan'] ?? 'JAKARTA'}", 
                            style: const TextStyle(color: Colors.white54, fontSize: 12)
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
                            decoration: BoxDecoration(
                              color: isLunas ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2), 
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isLunas ? Colors.greenAccent : Colors.orangeAccent, width: 0.5)
                            ), 
                            child: Text(
                              isLunas ? "LUNAS" : "BAYAR SEKARANG", 
                              style: TextStyle(
                                color: isLunas ? Colors.greenAccent : Colors.orangeAccent, 
                                fontSize: 9, 
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 15),
          const Text("Belum ada riwayat tiket.", style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }
}