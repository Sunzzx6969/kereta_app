import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Request Manual (Bypass Provider)
import 'dart:convert';
import 'dart:ui'; // Untuk Glassmorphism
import 'package:intl_phone_field/intl_phone_field.dart'; // IMPORT PENTING
import '../../utils/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nikCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  // _telpCtrl kita pakai untuk menampung hasil gabungan (+62 + nomor)
  final _telpCtrl = TextEditingController(); 
  final _alamatCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  // --- LOGIC REGISTER LANGSUNG (Bypass Provider biar aman) ---
  Future<void> _handleRegister() async {
    // 1. Validasi Input
    if (_nikCtrl.text.isEmpty ||
        _namaCtrl.text.isEmpty ||
        _userCtrl.text.isEmpty ||
        _passCtrl.text.isEmpty ||
        _telpCtrl.text.isEmpty || // Pastikan nomor telepon terisi
        _alamatCtrl.text.isEmpty) {
      _showError("Semua data wajib diisi!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Kirim Data ke Server
      final response = await http.post(
        Uri.parse("https://micke.my.id/api/ukk/register.php"),
        body: {
          'nik': _nikCtrl.text,
          'nama_penumpang': _namaCtrl.text,
          'username': _userCtrl.text,
          'password': _passCtrl.text,
          'telp': _telpCtrl.text, // Ini sudah berisi +62xxxxxx
          'alamat': _alamatCtrl.text,
        },
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      setState(() => _isLoading = false);

      // 3. Cek Hasil
      if (response.statusCode == 200 && data['status'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pendaftaran Berhasil! Silakan Login."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Kembali ke Login Screen
      } else {
        _showError(data['message'] ?? "Gagal Mendaftar. Username mungkin terpakai.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Koneksi Gagal. Cek internet Anda.");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1330), 
                    AppColors.primaryNavy,
                    Color(0xFF15264F),
                  ],
                ),
              ),
            ),
          ),
          // Glow Orange
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryOrange.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Bergabunglah dengan PEKERTA.IND",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),

                  const SizedBox(height: 30),

                  // GLASS CARD FORM
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 25, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel("DATA PRIBADI"),
                            const SizedBox(height: 15),
                            _buildPremiumField(controller: _namaCtrl, hint: "Nama Lengkap", icon: Icons.badge_rounded),
                            const SizedBox(height: 15),
                            _buildPremiumField(controller: _nikCtrl, hint: "Nomor NIK", icon: Icons.credit_card_rounded, isNumber: true),
                            const SizedBox(height: 15),
                            
                            // --- INPUT NO HP INTERNASIONAL (MODIFIKASI DISINI) ---
                            _buildInternationalPhoneField(), 
                            
                            const SizedBox(height: 15),
                            _buildPremiumField(controller: _alamatCtrl, hint: "Alamat Lengkap", icon: Icons.location_on_rounded, maxLines: 2),

                            const SizedBox(height: 25),
                            _buildSectionLabel("AKUN & KEAMANAN"),
                            const SizedBox(height: 15),
                            _buildPremiumField(controller: _userCtrl, hint: "Username", icon: Icons.person_rounded),
                            const SizedBox(height: 15),
                            _buildPremiumField(
                              controller: _passCtrl,
                              hint: "Password",
                              icon: Icons.lock_rounded,
                              isPass: _obscureText,
                              onSuffixPressed: () => setState(() => _obscureText = !_obscureText),
                            ),

                            const SizedBox(height: 35),

                            // TOMBOL REGISTER
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: const LinearGradient(
                                  colors: [AppColors.secondaryOrange, Color(0xFFFF6B00)],
                                ),
                                boxShadow: [
                                  BoxShadow(color: AppColors.secondaryOrange.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        "REGISTER NOW",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: TextStyle(color: Colors.white.withOpacity(0.7))),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("Login Here", style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(color: AppColors.secondaryOrange.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5),
    );
  }

  // --- WIDGET KHUSUS PHONE NUMBER (GLASSMORPHISM STYLE) ---
  Widget _buildInternationalPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Padding sedikit biar rapi
      child: IntlPhoneField(
        decoration: const InputDecoration(
          hintText: 'Nomor Telepon',
          hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
          border: InputBorder.none, // Hapus border bawaan library biar nyatu sama Container
          counterText: "", // Hapus hitungan karakter di bawah
          contentPadding: EdgeInsets.only(top: 14), // Sesuaikan posisi teks
        ),
        initialCountryCode: 'ID', // Default Indonesia
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600), // Teks input putih
        dropdownTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Teks kode negara putih
        dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.white), // Panah putih
        cursorColor: Colors.white,
        disableLengthCheck: false,
        onChanged: (phone) {
          // Simpan nomor lengkap (+62812...) ke controller kita
          _telpCtrl.text = phone.completeNumber;
        },
      ),
    );
  }

  Widget _buildPremiumField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPass = false,
    bool isNumber = false,
    int maxLines = 1,
    VoidCallback? onSuffixPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.9)),
          suffixIcon: isPass || onSuffixPressed != null
              ? IconButton(
                  icon: Icon(isPass ? Icons.visibility_off : Icons.visibility, color: Colors.white.withOpacity(0.6)),
                  onPressed: onSuffixPressed,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }
}