import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui'; // PENTING: Untuk efek Glassmorphism
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _obscureText = true;

  // --- 1. LOGIC WHATSAPP (BANTUAN LUPA PASSWORD) ---
  Future<void> _launchWhatsApp() async {
    // Nomor Admin (Sesuai request)
    String phoneNumber = "6281216455135"; 
    String message = "Halo Admin Pekerta, saya lupa password akun saya. Mohon bantuannya.";
    
    final Uri url = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal membuka WhatsApp. Pastikan aplikasi terinstall.")),
        );
      }
    } catch (e) {
      debugPrint("Error WA: $e");
    }
  }

  // --- 2. DIALOG LUPA PASSWORD ---
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B), // Navy Gelap
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.lock_reset, color: AppColors.secondaryOrange),
              SizedBox(width: 10),
              Text("Lupa Password?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Demi keamanan, reset password dilakukan melalui Admin. Hubungi via WhatsApp untuk bantuan.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: TextStyle(color: Colors.grey[400])),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.chat, color: Colors.white, size: 18),
              label: const Text("Chat Admin", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
                _launchWhatsApp();
              },
            ),
          ],
        );
      },
    );
  }

  // --- 3. LOGIC LOGIN (PEMISAHAN ROLE) ---
  Future<void> _handleLogin() async {
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _showError("Username dan Password wajib diisi.");
      return;
    }
    
    // Hilangkan Keyboard
    FocusScope.of(context).unfocus(); 

    try {
      // Panggil Provider (Sudah Anti-Macet)
      bool success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).login(_userCtrl.text, _passCtrl.text);

      if (success) {
        if (!mounted) return;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        // --- CEK ROLE DISINI ---
        if (authProvider.isPetugas) {
           // Jika Petugas -> Masuk Admin Home
           // Pastikan route '/admin-home' sudah didaftarkan di main.dart
           Navigator.pushReplacementNamed(context, '/admin-home');
        } else {
           // Jika Penumpang -> Masuk Home Biasa
           Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showError("Username atau Password salah.");
      }
    } catch (e) {
      _showError("Terjadi kesalahan sistem: $e");
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

  // --- UI BUILDER ---
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Stack(
        children: [
          // A. BACKGROUND GRADIENT
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1330), // Darkest Navy
                    AppColors.primaryNavy,
                    Color(0xFF15264F),
                  ],
                ),
              ),
            ),
          ),
          
          // B. GLOW EFFECT (Pojok Kanan Atas)
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

          // C. KONTEN UTAMA
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO
                  Image.asset(
                    'assets/images/only_login.png', // Pastikan path ini benar di pubspec.yaml
                    height: 130,
                    color: Colors.white,
                    errorBuilder: (ctx, err, stack) => const Icon(
                      Icons.directions_train_rounded,
                      size: 120,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "PEKERTA INDONESIA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Exclusive Travel Experience",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FORM CARD (GLASSMORPHISM)
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
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SELAMAT DATANG, PEKERTA FANS",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Input Fields
                            _buildPremiumField(
                              controller: _userCtrl,
                              hint: "Username",
                              icon: Icons.person_rounded,
                            ),
                            const SizedBox(height: 20),
                            _buildPremiumField(
                              controller: _passCtrl,
                              hint: "Password",
                              icon: Icons.lock_rounded,
                              isPass: _obscureText,
                              onSuffixPressed: () => setState(() => _obscureText = !_obscureText),
                            ),

                            const SizedBox(height: 15),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _showForgotPasswordDialog,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 30),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 35),

                            // Tombol Sign In
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                gradient: const LinearGradient(
                                  colors: [AppColors.secondaryOrange, Color(0xFFFF6B00)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondaryOrange.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                ),
                                child: authProvider.isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        "SIGN IN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          "Create One",
                          style: TextStyle(
                            color: AppColors.secondaryOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPass = false,
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.9)),
          suffixIcon: isPass || onSuffixPressed != null
              ? IconButton(
                  icon: Icon(
                    isPass ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.6),
                  ),
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