import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';
import '../../providers/admin_provider.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int? selectedSeatIndex;
  Map<String, dynamic>? selectedSeatData;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AdminProvider>(context, listen: false).fetchKursi());
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data jadwal yang dikirim dari halaman sebelumnya (opsional)
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Pilih Kursi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. Info Kereta & Gerbong
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  args?['nama'] ?? "KAI Express - Eksekutif",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Gerbong 1 (G1)",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // 2. Indikator Status Kursi
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _indicator(Colors.grey[300]!, "Terisi"),
                _indicator(Colors.white, "Tersedia"),
                _indicator(AppColors.secondaryOrange, "Pilihanmu"),
              ],
            ),
          ),

          // 3. Area Denah Kursi (Scrollable)
          Expanded(
            child: Consumer<AdminProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primaryNavy));
                }

                if (provider.kursiList.isEmpty) {
                  return Center(child: Text("Data kursi tidak ditemukan"));
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1),
                  itemCount: provider.kursiList.length,
                  itemBuilder: (context, index) {
                    var kursi = provider.kursiList[index];
                    bool isOccupied = kursi['status'] == 'terisi' || kursi['status'] == '0';
                    bool isSelected = selectedSeatIndex == index;

                    return GestureDetector(
                      onTap: isOccupied
                          ? null
                          : () => setState(() {
                                selectedSeatIndex = index;
                                selectedSeatData = kursi;
                              }),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isOccupied
                              ? Colors.grey[200]
                              : (isSelected ? AppColors.secondaryOrange : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isSelected
                                  ? AppColors.secondaryOrange
                                  : (isOccupied ? Colors.transparent : AppColors.primaryNavy.withOpacity(0.3)),
                              width: 2),
                          boxShadow: isSelected
                              ? [BoxShadow(color: AppColors.secondaryOrange.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))]
                              : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
                        ),
                        child: Center(
                          child: Text(
                            "${kursi['nama_kursi'] ?? kursi['nomor_kursi'] ?? index + 1}",
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isOccupied ? Colors.grey[400] : AppColors.primaryNavy),
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 4. Panel Konfirmasi Bawah (Glassmorphism effect style)
          Container(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, -5))]),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kursi Dipilih", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text(
                            selectedSeatData != null
                                ? "Nomor ${selectedSeatData!['nama_kursi']}"
                                : "Belum dipilih",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: AppColors.primaryNavy),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Total Harga", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text(
                            selectedSeatData != null ? "Rp 150.000" : "-", 
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.secondaryOrange),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  CustomButton(
                    text: "KONFIRMASI KURSI",
                    onPressed: selectedSeatIndex == null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Pilih kursi dulu, Bos!"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(),
                                settings: RouteSettings(arguments: selectedSeatData),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _indicator(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
                color: color,
                border: Border.all(color: AppColors.primaryNavy.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(4))),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
      ],
    );
  }
}