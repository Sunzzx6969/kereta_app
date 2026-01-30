import 'package:flutter/material.dart';
import 'dart:ui'; // WAJIB UNTUK EFEK BLUR KACA
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
        content: Text(msg, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Navy Background
      body: Stack(
        children: [
          // 1. NEON ORNAMENTS (Lingkaran Bercahaya)
          Positioned(top: 150, left: -50, child: _buildNeonCircle(180, Colors.cyanAccent)),
          Positioned(top: 50, right: -30, child: _buildNeonCircle(120, Colors.purpleAccent)),
          Positioned(bottom: 100, right: -50, child: _buildNeonCircle(200, Colors.blueAccent)),
          Positioned(bottom: 250, left: 20, child: _buildNeonCircle(80, Colors.pinkAccent)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // 2. HEADER TYPOGRAPHY
                  Text(
                    "PEKERTA.IND",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.cyanAccent, Colors.purpleAccent],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      letterSpacing: 2,
                    ),
                  ),
                  Text("ACCESS YOUR JOURNEY", 
                    style: TextStyle(color: Colors.white70, letterSpacing: 3, fontSize: 10, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 60),

                  // 3. GLASSMORPHISM CARD
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("SECURE LOGIN", 
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            Text("Enter your credentials to continue", 
                              style: TextStyle(color: Colors.white54, fontSize: 12)),
                            const SizedBox(height: 35),

                            _buildGlassField(_userCtrl, "USERNAME", Icons.person_outline),
                            const SizedBox(height: 20),
                            _buildGlassField(_passCtrl, "PASSWORD", Icons.lock_outline, isPass: true),
                            const SizedBox(height: 40),
                            
                            // 4. CYBER BUTTON
                            GestureDetector(
                              onTap: _isLoading ? null : _handleLogin,
                              child: Container(
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [Colors.cyanAccent, Colors.purpleAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    )
                                  ]
                                ),
                                child: Center(
                                  child: _isLoading 
                                    ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    : Text("SIGN IN", 
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // SIGN UP LINK
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'), 
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.white60),
                        children: [
                          TextSpan(
                            text: "Sign Up Now",
                            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Lingkaran Neon
  Widget _buildNeonCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 80,
            spreadRadius: 10,
          )
        ],
      ),
    );
  }

  // Helper Widget: Input Kaca
  Widget _buildGlassField(TextEditingController ctrl, String label, IconData icon, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPass,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.white30, fontSize: 12, letterSpacing: 2),
          prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}