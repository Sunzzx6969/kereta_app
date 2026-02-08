import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class PelangganManagementScreen extends StatefulWidget {
  const PelangganManagementScreen({super.key});

  @override
  State<PelangganManagementScreen> createState() => _PelangganManagementScreenState();
}

class _PelangganManagementScreenState extends State<PelangganManagementScreen> {
  // Simulasi data pelanggan (Nanti bisa ditarik dari API/Database)
  List<Map<String, String>> listPelanggan = [
    {"nama": "Andi Pratama", "email": "andi@mail.com", "telepon": "08123456789"},
    {"nama": "Siti Aminah", "email": "siti@mail.com", "telepon": "08987654321"},
    {"nama": "Rizky Ramadhan", "email": "rizky@mail.com", "telepon": "08556677889"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("DATA PELANGGAN", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // HEADER SEARCH (Opsional buat gaya)
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari nama pelanggan...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          Expanded(
            child: listPelanggan.isEmpty
                ? const Center(child: Text("Belum ada pelanggan terdaftar"))
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: listPelanggan.length,
                    itemBuilder: (context, index) {
                      final user = listPelanggan[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondaryOrange.withOpacity(0.1),
                            child: const Icon(Icons.person, color: AppColors.secondaryOrange),
                          ),
                          title: Text(user['nama']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${user['email']}\n${user['telepon']}"),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Bisa tambah fitur detail pelanggan di sini
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}