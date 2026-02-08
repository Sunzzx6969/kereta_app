import 'package:flutter/material.dart';
import 'package:kereta_app/screens/pelanggan/search_jadwal_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:ui'; // PENTING: Untuk efek Glassmorphism
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

// PROVIDERS
import '../../providers/admin_provider.dart'; 
import '../../providers/auth_provider.dart'; 
import '../../utils/colors.dart';

// SCREENS
import 'history_screen.dart';
import 'profile_screen.dart';
import 'inbox_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<AdminProvider>(context, listen: false).getJadwal(),
    );
  }

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // List Halaman
    final List<Widget> pages = [
      HomeContent(
        onTicketTap: () => switchTab(1), // Pindah ke Tab Tiket
        onProfileTap: () => switchTab(3), // Pindah ke Tab Akun
      ), 
      const HistoryScreen(), 
      const InboxScreen(), 
      const ProfileScreen(), 
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryNavy, 
      extendBody: true, 
      body: Stack(
        children: [
          // 1. GLOBAL BACKGROUND GRADIENT
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
          
          // 2. GLOW EFFECT
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryOrange.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 3. PAGE CONTENT
          pages[_currentIndex],
        ],
      ),

      // 4. FLOATING GLASS BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 25), 
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
            child: Container(
              color: Colors.white.withOpacity(0.1), 
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                backgroundColor: Colors.transparent, 
                selectedItemColor: AppColors.secondaryOrange, 
                unselectedItemColor: Colors.white.withOpacity(0.5), 
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                onTap: switchTab,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Beranda"),
                  BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_rounded), label: "Tiket"),
                  BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: "Inbox"),
                  BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- HOME CONTENT ---
class HomeContent extends StatefulWidget {
  final VoidCallback onTicketTap;
  final VoidCallback onProfileTap;

  const HomeContent({
    super.key, 
    required this.onTicketTap, 
    required this.onProfileTap
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _timeString = "--:--";
  String _dateString = "Memuat...";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initLocaleAndTimer();
  }

  Future<void> _initLocaleAndTimer() async {
    await initializeDateFormatting('id_ID', null);
    if (mounted) {
      _updateTime();
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = DateFormat('HH:mm').format(now);
        _dateString = DateFormat('EEEE, d MMM yyyy', 'id_ID').format(now);
      });
    }
  }

  // --- PERBAIKAN UTAMA DI SINI ---
  String _parseJam(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr == "-" || dateTimeStr == "null" || dateTimeStr.isEmpty) return "--:--";
    try {
      // 1. Cek apakah formatnya Tanggal Lengkap (YYYY-MM-DD HH:mm:ss)
      if (dateTimeStr.contains("-")) {
         DateTime dt = DateTime.parse(dateTimeStr);
         return DateFormat('HH:mm').format(dt); // Ambil Jam saja dari tanggal
      }
      
      // 2. Cek apakah formatnya cuma Jam (HH:mm:ss)
      // Pastikan tidak mengandung "-", baru kita substring
      if (dateTimeStr.contains(":") && !dateTimeStr.contains("-")) {
         if (dateTimeStr.length >= 5) return dateTimeStr.substring(0, 5);
      }
      
      // Fallback
      return dateTimeStr;
    } catch (e) {
      return "--:--";
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/6281216455135?text=Halo%20Admin%20Pekerta,%20saya%20butuh%20bantuan.");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print(e);
    }
  }

  String? _getPhotoUrl(String? rawPhoto) {
    if (rawPhoto == null || rawPhoto.isEmpty) return null;
    if (rawPhoto.startsWith('http')) return rawPhoto;
    return "https://micke.my.id/api/ukk/uploads/$rawPhoto"; 
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user; 
    final adminProv = Provider.of<AdminProvider>(context);

    ImageProvider? profileImage;
    String? photoUrl = _getPhotoUrl(user?.fotoProfil); 
    
    if (photoUrl != null) {
       profileImage = NetworkImage(photoUrl);
    }

    return CustomScrollView(
      slivers: [
        // 1. HEADER (Welcome & Profile)
        SliverAppBar(
          expandedHeight: 130.0,
          pinned: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Selamat Datang,", 
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 5),
                      Text(user?.nama ?? "Penumpang", 
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    ],
                  ),
                  
                  // --- FOTO PROFILE (CLICKABLE) ---
                  GestureDetector(
                    onTap: widget.onProfileTap, 
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondaryOrange, width: 2),
                        boxShadow: [
                          BoxShadow(color: AppColors.secondaryOrange.withOpacity(0.3), blurRadius: 10)
                        ]
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white24,
                        backgroundImage: profileImage,
                        child: profileImage == null 
                            ? const Icon(Icons.person, color: Colors.white) 
                            : null,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        // 2. GLASS CARD: JAM & MENU
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_dateString, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              Text("Waktu Saat Ini", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                            ],
                          ),
                          Text(_timeString, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        ],
                      ),
                      const Divider(color: Colors.white12, height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMenuIcon(Icons.search_rounded, "Cari", () { 
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchJadwalScreen()),
                            );
                          }),
                          _buildMenuIcon(Icons.confirmation_number_outlined, "Tiket", widget.onTicketTap),
                          _buildMenuIcon(Icons.help_outline_rounded, "Bantuan", _launchWhatsApp),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // 3. JUDUL LIST
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Jadwal Perjalanan", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.secondaryOrange),
                  onPressed: () => adminProv.getJadwal(),
                ),
              ],
            ),
          ),
        ),

        // 4. LIST JADWAL
        adminProv.isLoading
            ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Colors.white))))
            : adminProv.listJadwal.isEmpty
            ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(40), child: Text("Belum ada jadwal tersedia", style: TextStyle(color: Colors.white54)))))
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = adminProv.listJadwal[index];
                    return _buildGlassTicket(context, item);
                  },
                  childCount: adminProv.listJadwal.length,
                ),
              ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
      ],
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), 
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1))
            ),
            child: Icon(icon, color: AppColors.secondaryOrange, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildGlassTicket(BuildContext context, Map<String, dynamic> item) {
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    String hargaStr = currencyFormatter.format(int.tryParse(item['harga'].toString()) ?? 0);

    String namaKereta = item['nama_kereta'] ?? item['kereta_nama'] ?? 'Kereta';
    String asal = item['asal_keberangkatan'] ?? item['asal'] ?? '-';
    String tujuan = item['tujuan_keberangkatan'] ?? item['tujuan'] ?? '-';
    
    // Gunakan _parseJam yang sudah diperbaiki
    String jamBerangkat = _parseJam(item['tanggal_berangkat']);
    String jamTiba = _parseJam(item['tanggal_kedatangan']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.6), 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                   Navigator.pushNamed(context, '/booking', arguments: item);
                },
                splashColor: AppColors.secondaryOrange.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.train, color: Colors.white.withOpacity(0.8), size: 20),
                              const SizedBox(width: 8),
                              Text(namaKereta, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.5))
                            ),
                            child: Text(hargaStr, style: const TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _stationDetail(jamBerangkat, asal, CrossAxisAlignment.start),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.3), size: 24),
                            _stationDetail(jamTiba, tujuan, CrossAxisAlignment.end),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white10),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(Icons.touch_app_rounded, size: 14, color: Colors.white.withOpacity(0.5)),
                            const SizedBox(width: 5),
                            Text("Ketuk untuk pesan", style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stationDetail(String time, String station, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(station.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}