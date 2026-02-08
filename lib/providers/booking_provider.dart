import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class BookingProvider with ChangeNotifier {
  final String _baseUrl = 'https://micke.my.id/api/ukk';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // PENYIMPANAN LOKAL (Agar riwayat instan muncul)
  List<dynamic> _listHistory = [];
  List<dynamic> get listHistory => _listHistory;

  // 1. Ambil Gerbong
  Future<List<dynamic>> getGerbong(String idK) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/gerbong.php?id_kereta=$idK'));
      if (res.statusCode == 200) {
        final d = json.decode(res.body);
        return (d is Map && d['data'] != null) ? d['data'] : (d is List ? d : []);
      }
    } catch (e) { print(e); }
    return [];
  }

  // 2. Ambil Kursi
  Future<List<dynamic>> getKursi(String idG, String idJ) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/kursi.php?id_gerbong=$idG&id_jadwal=$idJ'));
      if (res.statusCode == 200) {
        final d = json.decode(res.body);
        return (d is Map && d['data'] != null) ? d['data'] : (d is List ? d : []);
      }
    } catch (e) { print(e); }
    return [];
  }

  // 3. Simpan Booking ke Lokal (STATUS PENDING)
  Future<Map<String, dynamic>> createBooking({required Map<String, dynamic> rawData}) async {
    _isLoading = true;
    notifyListeners();

    String id = "BK-${DateTime.now().millisecondsSinceEpoch}";
    
    // ANTI NULL: Pastikan Asal & Tujuan ada isinya
    final newTicket = {
      ...rawData,
      'id_booking': id,
      'status': 'pending',
      'asal': rawData['asal'] ?? 'JAKARTA', 
      'tujuan': rawData['tujuan'] ?? 'SURABAYA',
      'waktu_transaksi': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
    };

    _listHistory.insert(0, newTicket);
    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
    return {'success': true, 'id_booking': id};
  }

  // 4. Update Pembayaran ke Lokal (STATUS LUNAS)
  Future<void> bayarTiket(String id) async {
    int idx = _listHistory.indexWhere((t) => t['id_booking'] == id);
    if (idx != -1) {
      _listHistory[idx]['status'] = 'lunas';
      notifyListeners();
    }
  }

  // 5. Ambil Riwayat (FIX: ANTI ERROR MERAH)
  Future<void> getHistory(String id) async {
    _isLoading = true;
    // Gunakan microtask agar tidak bentrok dengan build UI
    Future.microtask(() => notifyListeners());
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoading = false;
    notifyListeners();
  }
}