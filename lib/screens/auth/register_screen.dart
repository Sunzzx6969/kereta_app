import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
  bool _obscureText = true;

  Future<void> _handleRegister() async {
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
          const SnackBar(content: Text("Daftar Berhasil! Silakan Masuk"), backgroundColor: Colors.green)
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
      SnackBar(
        content: Text(msg), 
        backgroundColor: Colors.redAccent, 
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER (Sama dengan Login)
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryNavy, const Color(0xFF0D1B3E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person_add_rounded, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "BUAT AKUN BARU",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            // 2. FORM REGISTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Data Pribadi"),
                  const SizedBox(height: 15),
                  _buildCustomField(controller: _namaCtrl, label: "Nama Lengkap", icon: Icons.badge_outlined),
                  const SizedBox(height: 15),
                  _buildCustomField(controller: _nikCtrl, label: "Nomor NIK", icon: Icons.assignment_ind_outlined),
                  const SizedBox(height: 15),
                  _buildCustomField(controller: _telpCtrl, label: "Nomor Telepon", icon: Icons.phone_android_outlined),
                  const SizedBox(height: 15),
                  _buildCustomField(controller: _alamatCtrl, label: "Alamat Lengkap", icon: Icons.location_on_outlined, maxLines: 2),
                  
                  const SizedBox(height: 25),
                  _buildLabel("Keamanan Akun"),
                  const SizedBox(height: 15),
                  _buildCustomField(controller: _userCtrl, label: "Username", icon: Icons.person_outline_rounded),
                  const SizedBox(height: 15),
                  _buildCustomField(
                    controller: _passCtrl, 
                    label: "Password", 
                    icon: Icons.lock_outline_rounded,
                    isPass: _obscureText,
                    suffix: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BUTTON REGISTER
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("DAFTAR SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BACK TO LOGIN
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          text: "Sudah punya akun? ",
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: "Login di sini",
                              style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryNavy.withOpacity(0.7), letterSpacing: 1));
  }

  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.primaryNavy),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        ),
      ),
    );
  }
}