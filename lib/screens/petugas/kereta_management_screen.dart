import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../utils/colors.dart';

class KeretaManagementScreen extends StatefulWidget {
  const KeretaManagementScreen({super.key});

  @override
  State<KeretaManagementScreen> createState() => _KeretaManagementScreenState();
}

class _KeretaManagementScreenState extends State<KeretaManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<AdminProvider>(context, listen: false).getKereta()
    );
  }

  // --- FUNGSI PINTAR: MENENTUKAN KURSI BERDASARKAN KELAS ---
  // Karena API tidak mengirim data kuota, kita pakai standar KAI saja
  String _hitungKursiDefault(String kelas, String? kuotaApi) {
    // 1. Jika API mengirim data valid (bukan 0 atau null), pakai data API
    if (kuotaApi != null && kuotaApi != "0" && kuotaApi != "null" && kuotaApi.isNotEmpty) {
      return kuotaApi;
    }

    // 2. Jika API kosong, tentukan berdasarkan kelas
    String k = kelas.toLowerCase();
    if (k.contains("eksekutif")) return "50"; // Standar Eksekutif
    if (k.contains("bisnis")) return "64";    // Standar Bisnis
    if (k.contains("luxury")) return "18";    // Standar Luxury
    
    return "80"; // Default Ekonomi (biasanya 80 atau 106)
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("MANAJEMEN ARMADA", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: adminProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminProv.listKereta.isEmpty
              ? const Center(child: Text("Belum ada data kereta"))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: adminProv.listKereta.length,
                  itemBuilder: (context, index) {
                    final rawData = adminProv.listKereta[index];

                    // 1. Ambil Data Dasar
                    String id = (rawData['id'] ?? rawData['id_kereta'] ?? rawData['id_armada']).toString();
                    String nama = (rawData['nama_kereta'] ?? rawData['nama'] ?? "Tanpa Nama").toString();
                    String deskripsi = (rawData['deskripsi'] ?? "-").toString();
                    String kelas = (rawData['kelas'] ?? "Ekonomi").toString();

                    // 2. Ambil Gerbong (Prioritas: jumlah_gerbong_aktif)
                    String gerbong = (rawData['jumlah_gerbong_aktif'] ?? rawData['jumlah_gerbong'] ?? rawData['gerbong'] ?? "0").toString();
                    
                    // 3. LOGIKA KUOTA / KURSI PER GERBONG
                    // Ambil raw data dari API dulu
                    String? rawKuota = (rawData['kuota'] ?? rawData['total_kuota'] ?? rawData['kapasitas'])?.toString();
                    
                    // Hitung fix-nya
                    String kursiPerGerbong = _hitungKursiDefault(kelas, rawKuota);
                    
                    // Hitung Total Kapasitas (Opsional: Gerbong x Kursi)
                    int totalKapasitas = (int.tryParse(gerbong) ?? 0) * (int.tryParse(kursiPerGerbong) ?? 0);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Icon Kereta
                            Container(
                              width: 50, height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.train_outlined, color: AppColors.secondaryOrange, size: 30),
                            ),
                            const SizedBox(width: 15),
                            
                            // Informasi Tengah
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text("$kelas • $deskripsi", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  const SizedBox(height: 8),
                                  
                                  // --- BAGIAN INI YANG MENAMPILKAN DATA ---
                                  Row(
                                    children: [
                                      _buildBadge(Icons.view_column, "$gerbong Gerbong"),
                                      const SizedBox(width: 8),
                                      _buildBadge(Icons.event_seat, "$kursiPerGerbong Kursi/Gerbong"),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Total Kapasitas: $totalKapasitas Penumpang", 
                                    style: TextStyle(fontSize: 10, color: Colors.green[700], fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),

                            // Tombol Hapus
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                if (id != "null" && id.isNotEmpty) {
                                   _confirmDelete(context, adminProv, id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryNavy,
        onPressed: () => _showAddDialog(context, adminProv),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget kecil untuk badge info
  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!)
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.black54),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminProvider prov, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Kereta?"),
        content: const Text("Data akan dihapus permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await prov.deleteKereta(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, AdminProvider prov) {
    final namaCtrl = TextEditingController();
    final deskripsiCtrl = TextEditingController();
    final gerbongCtrl = TextEditingController();
    final kuotaCtrl = TextEditingController();
    String kelas = "Ekonomi";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Tambah Kereta"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: "Nama Kereta")),
                TextField(controller: deskripsiCtrl, decoration: const InputDecoration(labelText: "Deskripsi")),
                TextField(controller: gerbongCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Jml Gerbong")),
                // Input Kuota manual (nanti dikirim ke server, meski server belum tentu balikin)
                TextField(controller: kuotaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Kursi Per Gerbong")),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: kelas,
                  items: ["Ekonomi", "Bisnis", "Eksekutif"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => kelas = v!),
                  decoration: const InputDecoration(labelText: "Kelas"),
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () async {
                if (namaCtrl.text.isNotEmpty) {
                  bool success = await prov.addKereta(
                    namaCtrl.text,
                    deskripsiCtrl.text,
                    kelas,
                    gerbongCtrl.text,
                    kuotaCtrl.text
                  );
                  if (success && context.mounted) Navigator.pop(context);
                }
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}