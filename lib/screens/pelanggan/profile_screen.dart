import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memicu pengambilan gambar
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        Navigator.pop(context); // Tutup pop-up setelah pilih foto
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // Fungsi memunculkan Pop-up pilihan (Ganti Foto)
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Ganti Foto Profil", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.primaryNavy),
                  title: const Text("Pilih dari Galeri"),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.primaryNavy),
                  title: const Text("Ambil Foto Kamera"),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER DENGAN FOTO INTERAKTIF
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryNavy, const Color(0xFF0D1B3E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Center(
                    child: Text("Profil Saya", 
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                // AREA FOTO PROFIL (Bisa Diketuk)
                Positioned(
                  bottom: -50,
                  child: GestureDetector(
                    onTap: _showPickerOptions, // KETUK FOTO UNTUK GANTI
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _imageFile != null 
                                ? FileImage(_imageFile!) 
                                : null,
                            child: _imageFile == null 
                                ? Icon(Icons.person, size: 60, color: AppColors.primaryNavy)
                                : null,
                          ),
                        ),
                        // Indikator kecil agar user tahu bisa diganti
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(color: AppColors.secondaryOrange, shape: BoxShape.circle),
                            child: const Icon(Icons.edit, size: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70),

            // NAMA & NIK
            Text(
              user?.namaLengkap ?? "Sultan Kereta",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Text("NIK: ${user?.nik ?? '-'}", style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            // CARD INFORMASI
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _infoTile(Icons.phone, "Telepon", user?.telp ?? "-"),
                  const Divider(),
                  _infoTile(Icons.location_on, "Alamat", user?.alamat ?? "-"),
                  const Divider(),
                  _infoTile(Icons.verified_user, "Role", user?.role?.toUpperCase() ?? "USER"),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _actionButton(
                    Icons.history, 
                    "Histori Pemesanan", 
                    AppColors.primaryNavy,
                    () => Navigator.pushNamed(context, '/history')
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    Icons.logout, 
                    "Keluar Akun", 
                    Colors.redAccent,
                    () {
                      userProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryNavy, size: 20),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 15),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              Icon(Icons.chevron_right, color: color.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}