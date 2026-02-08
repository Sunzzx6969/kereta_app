import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Pastikan URL ini sesuai dengan yang Anda pakai di AdminProvider
const String baseUrl = "https://micke.my.id/api/ukk";

class JadwalProvider with ChangeNotifier {
  bool _isLoading = false;
  List<dynamic> _listJadwal = [];

  bool get isLoading => _isLoading;
  List<dynamic> get listJadwal => _listJadwal;

  // --- FUNGSI AMBIL DATA JADWAL (KHUSUS PENUMPANG) ---
  Future<void> fetchJadwal() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Panggil API yang sama dengan Admin
      final response = await http.get(Uri.parse('$baseUrl/jadwal.php'));

      // Debug print biar tahu kalau data masuk
      print("--- FETCH JADWAL PENUMPANG ---");
      // print(response.body);

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        // Simpan data ke list
        _listJadwal = data['data'];
      } else {
        _listJadwal = [];
      }
    } catch (e) {
      print("Error Fetch Jadwal: $e");
      _listJadwal = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
