import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class TransaksiHistoryScreen extends StatefulWidget {
  const TransaksiHistoryScreen({super.key});

  @override
  State<TransaksiHistoryScreen> createState() => _TransaksiHistoryScreenState();
}

class _TransaksiHistoryScreenState extends State<TransaksiHistoryScreen> {
  // Simulasi data transaksi masuk
  List<Map<String, dynamic>> listTransaksi = [
    {
      "id_tiket": "TKT-001",
      "pelanggan": "Andi Pratama",
      "kereta": "Argo Bromo Anggrek",
      "status": "Lunas",
      "total": "Rp 450.000",
      "tanggal": "2026-02-06"
    },
    {
      "id_tiket": "TKT-002",
      "pelanggan": "Siti Aminah",
      "kereta": "Gajayana",
      "status": "Menunggu Verifikasi",
      "total": "Rp 350.000",
      "tanggal": "2026-02-06"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("RIWAYAT TRANSAKSI", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // RINGKASAN SINGKAT
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem("Total", "${listTransaksi.length}", Colors.blue),
                _buildSummaryItem("Pending", "1", Colors.orange),
                _buildSummaryItem("Sukses", "1", Colors.green),
              ],
            ),
          ),
          
          Expanded(
            child: listTransaksi.isEmpty
                ? const Center(child: Text("Belum ada transaksi"))
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: listTransaksi.length,
                    itemBuilder: (context, index) {
                      final trx = listTransaksi[index];
                      bool isPending = trx['status'] == "Menunggu Verifikasi";

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            backgroundColor: isPending ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                            child: Icon(
                              isPending ? Icons.hourglass_empty : Icons.check_circle_outline,
                              color: isPending ? Colors.orange : Colors.green,
                            ),
                          ),
                          title: Text(trx['id_tiket'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nama: ${trx['pelanggan']}"),
                              Text("Kereta: ${trx['kereta']}"),
                              Text("Tgl: ${trx['tanggal']}", style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(trx['total'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isPending ? Colors.orange : Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  isPending ? "Pending" : "Lunas",
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}