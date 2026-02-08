import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

// URL disesuaikan dengan yang kamu berikan (Tanpa folder /auth/)
const String baseUrl = "https://micke.my.id/api/ukk";

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  UserModel? _user;
  bool _isPetugas = false;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  bool get isPetugas => _isPetugas;
  bool get isAuth => _user != null;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("--- MENCOBA LOGIN ---");
      // Mengarah langsung ke login.php sesuai instruksimu
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {
          'username': username,
          'password': password,
        },
      ).timeout(const Duration(seconds: 10));

      print("RESPON SERVER: ${response.body}");

      final data = json.decode(response.body);

      // Cek status harus "success"
      if (data['status'] == 'success' && data['data'] != null) {
        var rawData = data['data'];
        var profile = rawData['profile'];
        String role = rawData['role'].toString().toLowerCase();

        // LOGIKA ADAPTIF: Karena nama_penumpang dan nama_petugas beda key
        String namaAsli = profile['nama_penumpang'] ?? profile['nama_petugas'] ?? "No Name";

        // Map ke UserModel (Pastikan field di UserModel.fromJson cocok dengan ini)
        _user = UserModel(
          id: rawData['user_id'].toString(),
          username: username, // Pakai input username
          nama: namaAsli,
          role: role,
          nik: profile['nik'] ?? "",
          telp: profile['telp'] ?? "",
          alamat: profile['alamat'] ?? "",
          fotoProfil: "", 
          token: "",
        );

        // Tentukan apakah dia admin/petugas
        _isPetugas = (role == 'admin' || role == 'petugas');

        // Simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(_user!.toJson()));
        
        print("LOGIN BERHASIL SEBAGAI: $role");
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        print("LOGIN GAGAL: ${data['message']}");
      }
    } catch (e) {
      print("ERROR SISTEM: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Fungsi Update Profile Lokal agar UI tidak merah
  Future<bool> updateProfile(String newName, String newTelp, String newAlamat) async {
    if (_user == null) return false;
    try {
      _user = UserModel(
        id: _user!.id,
        username: _user!.username,
        nama: newName,
        role: _user!.role,
        nik: _user!.nik,
        telp: newTelp,
        alamat: newAlamat,
        fotoProfil: _user!.fotoProfil,
        token: _user!.token,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(_user!.toJson()));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _isPetugas = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user_data')) return;
    try {
      final extractedUserData = json.decode(prefs.getString('user_data')!) as Map<String, dynamic>;
      _user = UserModel.fromJson(extractedUserData);
      String role = _user!.role.toLowerCase();
      _isPetugas = (role == 'admin' || role == 'petugas');
      notifyListeners();
    } catch (e) {}
  }
}