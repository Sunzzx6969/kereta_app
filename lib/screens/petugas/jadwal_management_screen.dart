import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../utils/colors.dart';

class JadwalManagementScreen extends StatefulWidget {
  const JadwalManagementScreen({super.key});

  @override
  State<JadwalManagementScreen> createState() => _JadwalManagementScreenState();
}

class _JadwalManagementScreenState extends State<JadwalManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final prov = Provider.of<AdminProvider>(context, listen: false);
      prov.getJadwal();
      prov.getKereta();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "MANAJEMEN JADWAL",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
      ),
      body: adminProv.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminProv.listJadwal.isEmpty
          ? _buildEmptyState(adminProv)
          : RefreshIndicator(
              onRefresh: () async {
                await adminProv.getJadwal();
                await adminProv.getKereta();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: adminProv.listJadwal.length,
                itemBuilder: (context, index) {
                  final jadwal = adminProv.listJadwal[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.confirmation_number_outlined,
                          color: AppColors.secondaryOrange,
                        ),
                      ),
                      title: Text(
                        "${jadwal['asal_keberangkatan']} ➔ ${jadwal['tujuan_keberangkatan']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID Kereta: ${jadwal['id_kereta'] ?? '-'}"),
                          Text("Berangkat: ${jadwal['tanggal_berangkat']}"),
                          Text(
                            "Harga: Rp ${jadwal['harga']}",
                            style: const TextStyle(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => adminProv.deleteJadwal(
                          jadwal['id_jadwal'].toString(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryOrange,
        onPressed: () {
          // Validasi sebelum buka dialog
          if (adminProv.listKereta.isEmpty) {
            _showWarning(context);
          } else {
            _showAddJadwalDialog(context, adminProv);
          }
        },
        child: const Icon(Icons.add_task, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(AdminProvider prov) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          const Text("Belum ada jadwal", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => prov.getJadwal(),
            child: const Text("Refresh Data"),
          ),
        ],
      ),
    );
  }

  void _showWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Kereta Kosong! Tambahkan Armada dulu."),
      ),
    );
  }

  void _showAddJadwalDialog(BuildContext context, AdminProvider prov) {
    final asalCtrl = TextEditingController();
    final tujuanCtrl = TextEditingController();
    final tglBerangkatCtrl = TextEditingController(text: "2026-02-06 08:00:00");
    final tglDatangCtrl = TextEditingController(text: "2026-02-06 12:00:00");
    final hargaCtrl = TextEditingController();

    // --- LANGKAH 1: DEBUG & BERSIHKAN DATA ---
    final List<Map<String, String>> cleanKeretaList = [];
    final Set<String> processedIds = {};

    print("--- MULAI DEBUG DATA KERETA ---");
    if (prov.listKereta.isEmpty) {
      print("DATA KOSONG DARI PROVIDER!");
    }

    for (var item in prov.listKereta) {
      // Print data mentah untuk dicek di Console (Run Tab)
      print("Data Mentah: $item");

      // COBA CARI ID DENGAN BERBAGAI KEMUNGKINAN KEY
      // Apakah namanya 'id_kereta'? atau 'id'? atau 'id_armada'?
      var rawId = item['id_kereta'] ?? item['id'] ?? item['id_armada'];
      var rawNama = item['nama_kereta'] ?? item['nama'] ?? "Tanpa Nama";

      final id = rawId?.toString();
      final nama = rawNama?.toString();

      // Hanya masukkan jika ID valid
      if (id != null &&
          id.isNotEmpty &&
          id != "null" &&
          !processedIds.contains(id)) {
        processedIds.add(id);
        cleanKeretaList.add({'id': id, 'nama': nama ?? "Tanpa Nama"});
      } else {
        print(">>> DATA DIBUANG KARENA ID NULL/DUPLIKAT: $item");
      }
    }
    print("--- TOTAL DATA VALID: ${cleanKeretaList.length} ---");

    // --- LANGKAH 2: VARIABLE STATE ---
    String? selectedKeretaId;

    // Jika data valid ada, otomatis pilih yang pertama biar dropdown tidak kosong/error
    if (cleanKeretaList.isNotEmpty) {
      selectedKeretaId = cleanKeretaList.first['id'];
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Tambah Jadwal"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Jika list kosong, tampilkan pesan error, bukan dropdown
                cleanKeretaList.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.red[50],
                        child: Text(
                          "Error: Data Kereta tidak terbaca. Cek Console untuk melihat struktur JSON.",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : DropdownButtonFormField<String>(
                        initialValue:
                            selectedKeretaId, // Value ini DIJAMIN ada di items karena diambil dari .first
                        isExpanded: true,
                        items: cleanKeretaList.map((k) {
                          return DropdownMenuItem<String>(
                            value: k['id'],
                            child: Text(
                              "${k['nama']} (ID: ${k['id']})",
                            ), // Tampilkan ID biar yakin
                          );
                        }).toList(),
                        onChanged: (val) {
                          setDialogState(() {
                            selectedKeretaId = val;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Pilih Kereta",
                          border: OutlineInputBorder(),
                        ),
                      ),
                const SizedBox(height: 15),
                TextField(
                  controller: asalCtrl,
                  decoration: const InputDecoration(labelText: "Asal (Kota)"),
                ),
                TextField(
                  controller: tujuanCtrl,
                  decoration: const InputDecoration(labelText: "Tujuan (Kota)"),
                ),
                TextField(
                  controller: tglBerangkatCtrl,
                  decoration: const InputDecoration(
                    labelText: "Tgl Berangkat (YYYY-MM-DD HH:MM:SS)",
                  ),
                ),
                TextField(
                  controller: tglDatangCtrl,
                  decoration: const InputDecoration(
                    labelText: "Tgl Tiba (YYYY-MM-DD HH:MM:SS)",
                  ),
                ),
                TextField(
                  controller: hargaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Harga (Angka)"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
              ),
              onPressed: cleanKeretaList.isEmpty
                  ? null
                  : () async {
                      // Disable jika data kosong
                      if (selectedKeretaId != null &&
                          asalCtrl.text.isNotEmpty &&
                          hargaCtrl.text.isNotEmpty) {
                        bool sukses = await prov.addJadwal({
                          'id_kereta': selectedKeretaId!,
                          'asal_keberangkatan': asalCtrl.text,
                          'tujuan_keberangkatan': tujuanCtrl.text,
                          'tanggal_berangkat': tglBerangkatCtrl.text,
                          'tanggal_kedatangan': tglDatangCtrl.text,
                          'harga': hargaCtrl.text,
                        });

                        if (sukses && context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Berhasil simpan Jadwal!"),
                            ),
                          );
                          prov.getJadwal();
                        }
                      }
                    },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
