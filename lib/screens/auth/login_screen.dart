import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _handleLogin() async {
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _showError("Username dan Password harus diisi");
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse("https://micke.my.id/api/ukk/login.php"),
        body: {"username": _userCtrl.text, "password": _passCtrl.text},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success" && data['data'] != null) {
          UserModel user = UserModel.fromJson(data);
          String userRole = data['data']['role']?.toString().toLowerCase() ?? "penumpang";
          bool isPetugas = userRole == "petugas" || userRole == "admin"; 
          Provider.of<AuthProvider>(context, listen: false).login(user, isPetugas);
          Navigator.pushReplacementNamed(context, isPetugas ? '/admin-home' : '/home');
        } else {
          _showError(data['message'] ?? "Username atau Password salah!");
        }
      } else {
        _showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Koneksi gagal: Pastikan internet aktif");
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
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            // 1. HEADER DENGAN LOGO (Linier dengan Navy Theme)
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryNavy, Color(0xFF0D1B3E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TARUH LOGO PEKERTA DISINI
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_pekerta.png', // Pastikan path ini benar di pubspec.yaml
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.directions_train_rounded, size: 80, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "PEKERTA INDONESIA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            // 2. FORM LOGIN (Clean & Elegant)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Selamat Datang!", 
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                  Text("Silakan masuk untuk melanjutkan perjalanan", 
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                  
                  const SizedBox(height: 40),

                  // INPUT USERNAME
                  _buildCustomField(
                    controller: _userCtrl,
                    label: "Username",
                    icon: Icons.person_outline_rounded,
                  ),
                  
                  const SizedBox(height: 20),

                  // INPUT PASSWORD
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

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Lupa Password?", style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 40),

                  // BUTTON LOGIN (Linier dengan Orange Accent)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        shadowColor: AppColors.primaryNavy.withOpacity(0.4),
                      ),
                      child: _isLoading 
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("MASUK SEKARANG", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // REGISTER LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum punya akun? "),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text("Daftar Disini", 
                          style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper UI: Input Field Elegant
  Widget _buildCustomField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPass,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(icon, color: AppColors.primaryNavy),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}