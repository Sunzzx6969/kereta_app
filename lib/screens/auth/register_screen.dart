import 'package:flutter/material.dart';
import 'dart:ui'; // WAJIB UNTUK EFEK BLUR KACA
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _telpCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    // Validasi sederhana
    if (_namaCtrl.text.isEmpty || _nikCtrl.text.isEmpty || _userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _showError("Harap isi semua kolom wajib");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("https://micke.my.id/api/ukk/register.php"),
        body: {
          "username": _userCtrl.text,
          "password": _passCtrl.text,
          "nama_penumpang": _namaCtrl.text,
          "nik": _nikCtrl.text,
          "alamat": _alamatCtrl.text,
          "telp": _telpCtrl.text,
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Daftar Berhasil! Silakan Masuk"), backgroundColor: Colors.green)
        );
        Navigator.pop(context);
      } else {
        _showError(data['message'] ?? "Registrasi Gagal");
      }
    } catch (e) {
      _showError("Koneksi gagal: Cek internet Anda");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Latar Navy Gelap (Sama dengan Login)
      body: Stack(
        children: [
          // 1. NEON ORNAMENTS (Posisi dibedakan dikit biar gak bosen)
          Positioned(top: -50, right: -50, child: _buildNeonCircle(200, Colors.purpleAccent)),
          Positioned(bottom: 100, left: -80, child: _buildNeonCircle(250, Colors.cyanAccent)),
          Positioned(top: 300, right: 20, child: _buildNeonCircle(100, Colors.blueAccent)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                children: [
                  // 2. HEADER
                  Text(
                    "JOIN JOURNEY",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.purpleAccent, Colors.cyanAccent],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 3. GLASSMORPHISM FORM
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            _buildGlassInput(_namaCtrl, "NAMA LENGKAP", Icons.badge_outlined),
                            const SizedBox(height: 15),
                            _buildGlassInput(_nikCtrl, "NIK", Icons.assignment_ind_outlined),
                            const SizedBox(height: 15),
                            _buildGlassInput(_userCtrl, "USERNAME", Icons.person_outline),
                            const SizedBox(height: 15),
                            _buildGlassInput(_passCtrl, "PASSWORD", Icons.lock_outline, isPass: true),
                            const SizedBox(height: 15),
                            _buildGlassInput(_telpCtrl, "NO. TELEPON", Icons.phone_android_outlined),
                            const SizedBox(height: 15),
                            _buildGlassInput(_alamatCtrl, "ALAMAT", Icons.location_on_outlined, maxLines: 2),
                            
                            const SizedBox(height: 35),

                            // 4. CYBER BUTTON REGISTER
                            GestureDetector(
                              onTap: _isLoading ? null : _handleRegister,
                              child: Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [Colors.purpleAccent, Colors.cyanAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purpleAccent.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    )
                                  ]
                                ),
                                child: Center(
                                  child: _isLoading 
                                    ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    : Text("REGISTER NOW", 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Already have an account? Login", 
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Neon Decoration Helper
  Widget _buildNeonCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 70,
            spreadRadius: 5,
          )
        ],
      ),
    );
  }

  // Glass Input Helper
  Widget _buildGlassInput(TextEditingController ctrl, String label, IconData icon, {bool isPass = false, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.white30, fontSize: 11, letterSpacing: 1.5),
          prefixIcon: Icon(icon, color: Colors.purpleAccent, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        ),
      ),
    );
  }
}