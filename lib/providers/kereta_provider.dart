import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KeretaProvider with ChangeNotifier {
  List<Map<String, dynamic>> _listKereta = [];
  List<Map<String, dynamic>> get listKereta => _listKereta;

  final String _baseUrl = "https://micke.my.id/api/ukk";

  Future<void> fetchKereta() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/kereta.php"));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'success' && result['data'] != null) {
          _listKereta = List<Map<String, dynamic>>.from(result['data']);
          notifyListeners();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> tambahKereta(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/kereta.php"),
        body: {
          'nama_kereta': data['nama_kereta'],
          'deskripsi': data['deskripsi'],
          'kelas': data['kelas'],
          'alamat': '-', 
          'telp': '-'
        },
      );

      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        await fetchKereta(); 
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hapusKereta(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/kereta.php?id=$id"),
      );
      
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        _listKereta.removeWhere((item) => item['id_kereta'] == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}