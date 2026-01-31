import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../providers/admin_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedGerbong = 1;
  int? selectedSeatIndex;
  Map<String, dynamic>? selectedSeatData;
  
  // SOP: 1 Gerbong = 60 Kursi (15 Baris x 4 Kolom)
  final int seatsPerGerbong = 60;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AdminProvider>(context, listen: false).fetchKursi());
  }

  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final int hargaTiket = int.tryParse(args?['harga']?.toString() ?? "0") ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Pilih Kursi & Gerbong", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. SELECTOR GERBONG
          _buildGerbongTabs(),

          // 2. INDIKATOR STATUS
          _buildStatusIndicators(),

          // 3. AREA DENAH KURSI
          Expanded(
            child: Consumer<AdminProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primaryNavy));
                }

                int startIdx = (selectedGerbong - 1) * seatsPerGerbong;
                int endIdx = startIdx + seatsPerGerbong;
                
                List currentGerbongSeats = [];
                if (provider.kursiList.length >= endIdx) {
                  currentGerbongSeats = provider.kursiList.sublist(startIdx, endIdx);
                } else if (provider.kursiList.length > startIdx) {
                  currentGerbongSeats = provider.kursiList.sublist(startIdx);
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView.builder(
                    itemCount: 15, // 15 Baris
                    itemBuilder: (context, rowIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSeatCell(currentGerbongSeats, rowIndex * 4, 'A'),
                            const SizedBox(width: 8),
                            _buildSeatCell(currentGerbongSeats, rowIndex * 4 + 1, 'B'),
                            
                            Container(
                              width: 45,
                              alignment: Alignment.center,
                              child: Text("${rowIndex + 1}", 
                                style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold)),
                            ),

                            _buildSeatCell(currentGerbongSeats, rowIndex * 4 + 2, 'C'),
                            const SizedBox(width: 8),
                            _buildSeatCell(currentGerbongSeats, rowIndex * 4 + 3, 'D'),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // 4. PANEL KONFIRMASI
          _buildBottomPanel(hargaTiket, args),
        ],
      ),
    );
  }

  Widget _buildGerbongTabs() {
    return Container(
      height: 65,
      color: AppColors.primaryNavy,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: 5,
        itemBuilder: (context, index) {
          int gNum = index + 1;
          bool isSelected = selectedGerbong == gNum;
          return GestureDetector(
            onTap: () => setState(() {
              selectedGerbong = gNum;
              selectedSeatIndex = null;
              selectedSeatData = null;
            }),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryOrange : Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text("Gerbong $gNum", 
                  style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _indicatorItem(Colors.grey[300]!, "Terisi"),
          const SizedBox(width: 25),
          _indicatorItem(Colors.white, "Tersedia"),
          const SizedBox(width: 25),
          _indicatorItem(AppColors.secondaryOrange, "Pilihanmu"),
        ],
      ),
    );
  }

  Widget _indicatorItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14, 
          height: 14, 
          decoration: BoxDecoration(
            color: color, 
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!)
          )
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSeatCell(List seats, int index, String letter) {
    if (index >= seats.length) return const SizedBox(width: 50);

    var kursi = seats[index];
    bool isOccupied = kursi['status'] == 'terisi' || kursi['status'] == '0';
    bool isSelected = selectedSeatIndex == index;
    String seatLabel = "${(index ~/ 4) + 1}$letter";

    return GestureDetector(
      onTap: isOccupied ? null : () => setState(() {
        selectedSeatIndex = index;
        selectedSeatData = Map<String, dynamic>.from(kursi);
        selectedSeatData!['seat_label'] = seatLabel;
        selectedSeatData!['gerbong_pilihan'] = selectedGerbong;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isOccupied ? Colors.grey[200] : (isSelected ? AppColors.secondaryOrange : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.secondaryOrange : (isOccupied ? Colors.transparent : AppColors.primaryNavy.withOpacity(0.1)),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(seatLabel, 
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : (isOccupied ? Colors.grey[400] : AppColors.primaryNavy),
            )),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(int harga, Map? args) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kursi Dipilih", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text(selectedSeatData != null ? "G$selectedGerbong - ${selectedSeatData!['seat_label']}" : "Belum Pilih", 
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primaryNavy)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Total Bayar", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  Text(AppHelpers.formatRupiah(harga), 
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.secondaryOrange)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          CustomButton(
            text: "KONFIRMASI KURSI",
            onPressed: selectedSeatIndex == null 
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Silakan pilih kursi terlebih dahulu"), behavior: SnackBarBehavior.floating))
              : () {
                  Navigator.pushNamed(context, '/payment', arguments: {
                    'jadwal': args,
                    'kursi': selectedSeatData,
                    'total_harga': harga,
                  });
                },
          ),
        ],
      ),
    );
  }
}