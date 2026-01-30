import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://micke.my.id/api/ukk";

  // --- AUTH API ---
  static Future<Map<String, dynamic>> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      body: {'username': username, 'password': password},
    ).timeout(Duration(seconds: 10)); // Tambah timeout agar tidak stuck

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'status': 'error', 'message': 'Server Error: ${response.statusCode}'};
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Gagal terhubung ke server'};
  }
}

  static Future<Map<String, dynamic>> registerPelanggan(Map<String, String> data) async {
    // Sesuai arahan: Booking/Register menggunakan register.php
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      body: data,
    );
    return jsonDecode(response.body);
  }

  // --- PELANGGAN API ---
  static Future<List<dynamic>> getKursi() async {
    final response = await http.get(Uri.parse("$baseUrl/kursi.php"));
    final data = jsonDecode(response.body);
    return data is List ? data : (data['data'] ?? []);
  }

  // --- PETUGAS API (Manajemen Data) ---
  static Future<List<dynamic>> getKereta() async {
    final response = await http.get(Uri.parse("$baseUrl/kereta.php"));
    final data = jsonDecode(response.body);
    return data is List ? data : (data['data'] ?? []);
  }

  static Future<List<dynamic>> getJadwal() async {
    final response = await http.get(Uri.parse("$baseUrl/jadwal.php"));
    final data = jsonDecode(response.body);
    return data is List ? data : (data['data'] ?? []);
  }

  static Future<List<dynamic>> getGerbong() async {
    final response = await http.get(Uri.parse("$baseUrl/gerbong.php"));
    final data = jsonDecode(response.body);
    return data is List ? data : (data['data'] ?? []);
  }
}