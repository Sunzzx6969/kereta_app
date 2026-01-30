import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class JadwalCard extends StatelessWidget {
  final String namaKereta;
  final String rute;
  final String waktu;
  final String harga;
  final VoidCallback onTap;

  JadwalCard({
    required this.namaKereta,
    required this.rute,
    required this.waktu,
    required this.harga,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: onTap, // Ini yang menjalankan navigasi
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.train, color: AppColors.primaryNavy, size: 40),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(namaKereta, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(rute, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    Text(waktu, style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Text(
                AppHelpers.formatRupiah(int.parse(harga)),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}