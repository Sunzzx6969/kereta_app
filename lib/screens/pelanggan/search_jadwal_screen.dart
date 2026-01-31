import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import 'package:intl/intl.dart'; // Tambahkan intl di pubspec.yaml jika belum ada

class SearchJadwalScreen extends StatefulWidget {
  const SearchJadwalScreen({super.key});

  @override
  _SearchJadwalScreenState createState() => _SearchJadwalScreenState();
}

class _SearchJadwalScreenState extends State<SearchJadwalScreen> {
  String asal = "Jakarta (GMR)";
  String tujuan = "Surabaya (SBI)";
  DateTime selectedDate = DateTime.now();
  int penumpang = 1;

  // Fungsi pilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryNavy),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Cari Tiket", style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER BACKGROUND
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryNavy,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),

            // CARD PENCARIAN
            Container(
              transform: Matrix4.translationValues(0, -60, 0),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  // ASAL
                  _buildSelectionTile(
                    label: "Stasiun Asal",
                    value: asal,
                    icon: Icons.location_on_rounded,
                    onTap: () {}, // Tambahkan navigasi pilih stasiun jika perlu
                  ),

                  // SWAP BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              String temp = asal;
                              asal = tujuan;
                              tujuan = temp;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryOrange.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.swap_vert_rounded, color: AppColors.secondaryOrange, size: 28),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),

                  // TUJUAN
                  _buildSelectionTile(
                    label: "Stasiun Tujuan",
                    value: tujuan,
                    icon: Icons.flag_rounded,
                    onTap: () {},
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),

                  // TANGGAL & PENUMPANG
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectionTile(
                          label: "Tanggal Pergi",
                          value: DateFormat('EEE, d MMM yyyy').format(selectedDate),
                          icon: Icons.calendar_today_rounded,
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildSelectionTile(
                          label: "Penumpang",
                          value: "$penumpang Orang",
                          icon: Icons.group_rounded,
                          onTap: () {
                            setState(() => penumpang < 5 ? penumpang++ : penumpang = 1);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // TOMBOL CARI
                  CustomButton(
                    text: "CARI JADWAL",
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                  ),
                ],
              ),
            ),
            
            // FOOTER INFO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Icon(Icons.verified_rounded, color: Colors.grey[300], size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Pemesanan aman dan terpercaya dengan sistem e-ticketing resmi KAI.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryNavy, size: 22),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                  const SizedBox(height: 2),
                  Text(value, 
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.blueGrey, size: 18),
          ],
        ),
      ),
    );
  }
}