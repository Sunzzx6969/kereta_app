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

  // AMBIL JADWAL (Untuk Home Pelanggan)
  Future<void> fetchJadwal() async {
    _isLoading = true;
    notifyListeners();
    try {
      _jadwalList = await ApiService.getJadwal();
    } catch (e) {
      print("Error Jadwal: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // AMBIL KERETA (Untuk Panel Petugas)
  Future<void> fetchKereta() async {
    _isLoading = true;
    notifyListeners();
    try {
      _keretaList = await ApiService.getKereta();
    } catch (e) {
      print("Error Kereta: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // AMBIL KURSI (Untuk Booking Pelanggan)
  Future<void> fetchKursi() async {
    _isLoading = true;
    notifyListeners();
    try {
      _kursiList = await ApiService.getKursi();
    } catch (e) {
      print("Error Kursi: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}