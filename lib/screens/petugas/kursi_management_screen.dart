import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/colors.dart';

class KursiManagementScreen extends StatefulWidget {
  const KursiManagementScreen({super.key});

  @override
  State<KursiManagementScreen> createState() => _KursiManagementScreenState();
}

class _KursiManagementScreenState extends State<KursiManagementScreen> {
  // State Pilihan
  String? _selectedJadwalId;
  String? _selectedGerbongId;

  // Data Dinamis
  List<Map<String, String>> _listGerbong = [];
  List<dynamic> _listKursiAvailable = []; // Hanya berisi kursi kosong
  bool _isLoadingKursi = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadJadwal();
      _isInit = false;
    }
  }

  Future<void> _loadJadwal() async {
    await Provider.of<AdminProvider>(context, listen: false).getJadwal();

    if (!mounted) return;
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

    // Auto-select jadwal pertama jika ada
    if (adminProv.listJadwal.isNotEmpty) {
      final firstJadwal = adminProv.listJadwal.first;
      var id = firstJadwal['id_jadwal'] ?? firstJadwal['id'];
      if (id != null) {
        _onJadwalChanged(id.toString());
      }
    }
  }

  void _onJadwalChanged(String? jadwalId) async {
    if (jadwalId == null) return;

    setState(() {
      _selectedJadwalId = jadwalId;
      _selectedGerbongId = null;
      _listGerbong = [];
      _listKursiAvailable = [];
    });

    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    final jadwalData = adminProv.listJadwal.firstWhere(
      (j) => (j['id_jadwal'] ?? j['id']).toString() == jadwalId,
      orElse: () => {},
    );

    if (jadwalData.isEmpty) return;

    String idKereta = (jadwalData['id_kereta'] ?? jadwalData['id_armada'] ?? jadwalData['kereta_id'] ?? '0').toString();

    // Ambil Gerbong
    final bookingProv = Provider.of<BookingProvider>(context, listen: false);
    final rawGerbong = await bookingProv.getGerbong(idKereta);

    if (!mounted) return;

    setState(() {
      _listGerbong = [];
      Set<String> uniqueIds = {};

      int index = 1;
      for (var item in rawGerbong) {
        String id = (item['id_gerbong'] ?? item['id'] ?? '').toString();
        String nama = (item['nama_gerbong'] ?? item['nama'] ?? "Gerbong $index").toString();

        if (id.isNotEmpty && id != "null" && !uniqueIds.contains(id)) {
          uniqueIds.add(id);
          _listGerbong.add({'id': id, 'nama': nama});
          index++;
        }
      }

      // Fallback Dummy jika API kosong (Biar UI tetap muncul saat demo)
      if (_listGerbong.isEmpty) {
         for(int i=1; i<=5; i++) {
           _listGerbong.add({'id': i.toString(), 'nama': 'Gerbong $i'});
         }
      }

      // Auto select gerbong pertama
      if (_listGerbong.isNotEmpty) {
        _onGerbongChanged(_listGerbong.first['id']);
      }
    });
  }

  void _onGerbongChanged(String? gerbongId) async {
    if (gerbongId == null || _selectedJadwalId == null) return;

    setState(() {
      _selectedGerbongId = gerbongId;
      _isLoadingKursi = true;
    });

    final bookingProv = Provider.of<BookingProvider>(context, listen: false);

    // API ini hanya mengembalikan kursi yang KOSONG (Available)
    final rawKursi = await bookingProv.getKursi(gerbongId, _selectedJadwalId!);

    if (!mounted) return;

    setState(() {
      _listKursiAvailable = rawKursi; // Simpan data kursi kosong
      _isLoadingKursi = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);
    
    // Filter jadwal valid
    final validJadwalList = adminProv.listJadwal.where((j) {
      var id = j['id_jadwal'] ?? j['id'];
      return id != null && id.toString() != "null" && id.toString().isNotEmpty;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("MANAJEMEN KURSI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadJadwal,
          )
        ],
      ),
      body: adminProv.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryNavy))
          : Column(
              children: [
                // --- 1. FILTER SECTION (Putih) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown Jadwal
                      const Text("Pilih Jadwal", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text("Pilih Jadwal Kereta"),
                            value: _selectedJadwalId,
                            items: validJadwalList.isEmpty
                                ? []
                                : validJadwalList.map((j) {
                                    String id = (j['id_jadwal'] ?? j['id']).toString();
                                    String nama = j['nama_kereta'] ?? 'Kereta';
                                    String rute = "${j['asal_keberangkatan']} ➝ ${j['tujuan_keberangkatan']}";
                                    return DropdownMenuItem(
                                      value: id,
                                      child: Text("$nama ($rute)", overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                            onChanged: validJadwalList.isEmpty ? null : _onJadwalChanged,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 15),
                      
                      // Chips Gerbong
                      if (_listGerbong.isNotEmpty) ...[
                        const Text("Pilih Gerbong", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listGerbong.length,
                            itemBuilder: (ctx, index) {
                              final g = _listGerbong[index];
                              final isSelected = _selectedGerbongId == g['id'];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(g['nama']!),
                                  selected: isSelected,
                                  selectedColor: AppColors.secondaryOrange,
                                  backgroundColor: Colors.grey.shade200,
                                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                                  onSelected: (val) { if (val) _onGerbongChanged(g['id']); },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // --- 2. DENAH KURSI SECTION ---
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8FAFC),
                    child: _buildBodyContent(),
                  ),
                ),

                // --- 3. LEGEND (Keterangan) ---
                if (_selectedJadwalId != null && _selectedGerbongId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusInfo(Colors.white, AppColors.primaryNavy, "Tersedia (Putih)"),
                        _buildStatusInfo(const Color(0xFFFFEBEE), Colors.red.shade300, "Terisi (Merah)", icon: Icons.block),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildBodyContent() {
    if (_selectedJadwalId == null) return _buildPrompt("Pilih Jadwal terlebih dahulu");
    if (_listGerbong.isEmpty) return _buildPrompt("Tidak ada data gerbong");
    if (_selectedGerbongId == null) return _buildPrompt("Pilih Gerbong");
    if (_isLoadingKursi) return const Center(child: CircularProgressIndicator(color: AppColors.secondaryOrange));

    // --- LOGIKA GRID ---
    // Asumsi 50 kursi per gerbong (5 kolom x 10 baris)
    int totalKursiPerGerbong = 50;

    return GridView.builder(
      padding: const EdgeInsets.all(25),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 5 Kolom biar rapi
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: totalKursiPerGerbong,
      itemBuilder: (context, index) {
        String nomorKursiSaatIni = (index + 1).toString();

        // LOGIKA KUNCI:
        // Cek apakah nomor kursi ini ADA di list API?
        // API hanya kirim yang available.
        bool isAvailable = _listKursiAvailable.any((k) {
          String no = (k['no_kursi'] ?? k['nomor_kursi'] ?? k['nomor'] ?? '').toString();
          return no == nomorKursiSaatIni;
        });

        // Kalau TIDAK ADA di list available, berarti BOOKED
        bool isBooked = !isAvailable; 

        return Container(
          decoration: BoxDecoration(
            color: isBooked ? const Color(0xFFFFEBEE) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isBooked ? Colors.red.shade300 : AppColors.primaryNavy.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: isBooked ? [] : [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 2))
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  nomorKursiSaatIni,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isBooked ? Colors.red.shade300 : AppColors.primaryNavy,
                  ),
                ),
              ),
              if (isBooked)
                Center(
                  child: Icon(Icons.close, color: Colors.red.withOpacity(0.3), size: 30),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusInfo(Color bg, Color border, String label, {IconData? icon}) {
    return Row(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
          child: icon != null ? Icon(icon, size: 16, color: border) : null,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }

  Widget _buildPrompt(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_seat, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}