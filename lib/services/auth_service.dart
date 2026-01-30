import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://micke.my.id/api/ukk";

  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String nama,
    required String nik,
    required String telp,
    required String alamat,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          "username": username,
          "password": password,
          "nama_penumpang": nama,
          "nik": nik,
          "telp": telp,
          "alamat": alamat,
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}