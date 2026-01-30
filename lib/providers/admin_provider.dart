import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminProvider with ChangeNotifier {
  List<dynamic> _jadwalList = [];
  List<dynamic> _keretaList = [];
  List<dynamic> _kursiList = [];
  bool _isLoading = false;

  List<dynamic> get jadwalList => _jadwalList;
  List<dynamic> get keretaList => _keretaList;
  List<dynamic> get kursiList => _kursiList;
  bool get isLoading => _isLoading;

  Future<void> fetchJadwal() async {
    _isLoading = true;
    notifyListeners();
    try { _jadwalList = await ApiService.getJadwal(); } catch (e) { print(e); }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchKereta() async {
    _isLoading = true;
    notifyListeners();
    try { _keretaList = await ApiService.getKereta(); } catch (e) { print(e); }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchKursi() async {
    _isLoading = true;
    notifyListeners();
    try { _kursiList = await ApiService.getKursi(); } catch (e) { print(e); }
    _isLoading = false;
    notifyListeners();
  }

  // FUNGSI UTAMA: Harus memanggil ApiService.updateKursi
  Future<void> updateKursiStatus(String idKursi, String status) async {
    try {
      // MEMANGGIL API SERVICE
      await ApiService.updateKursi(idKursi, status);
      
      // Update lokal agar UI berubah
      int index = _kursiList.indexWhere((k) => k['id_kursi'].toString() == idKursi);
      if (index != -1) {
        _kursiList[index]['status'] = status;
        notifyListeners();
      }
    } catch (e) {
      print("Error di Provider: $e");
      rethrow;
    }
  }
}