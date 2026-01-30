import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; 
import 'package:intl/intl.dart'; 
import 'package:intl/date_symbol_data_local.dart'; 
import 'package:url_launcher/url_launcher.dart'; // Pastikan sudah install package ini
import 'history_screen.dart';
import 'profile_screen.dart';
import 'inbox_screen.dart'; 
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../providers/admin_provider.dart';
import 'dart:ui';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<AdminProvider>(context, listen: false).fetchJadwal()
    );
  }

  final List<Widget> _children = [
    HomeContent(),
    HistoryScreen(),
    InboxScreen(), 
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, 10))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: AppColors.primaryNavy,
              unselectedItemColor: Colors.grey.withOpacity(0.8),
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.directions_train_rounded), label: "Beranda"),
                BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_rounded), label: "Tiket Saya"),
                BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: "Inbox"),
                BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _timeString = "--:--:--";
  String _dateString = "Memuat...";
  Timer? _timer;
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initLocaleAndTimer();
  }

  Future<void> _initLocaleAndTimer() async {
    await initializeDateFormatting('id_ID', null);
    if (mounted) {
      setState(() {
        _isLocaleInitialized = true;
        _updateTime();
      });
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!_isLocaleInitialized) return;
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = DateFormat('HH:mm:ss').format(now);
      _dateString = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
    });
  }

  // FITUR CARI TIKET (POP UP KALENDER)
  Future<void> _showSearchDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryNavy),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mencari jadwal untuk: ${DateFormat('dd MMMM yyyy', 'id_ID').format(pickedDate)}"))
      );
    }
  }

  // FITUR BANTUAN (WHATSAPP) - VERSI ANTI ERROR
  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/6281216455135?text=Halo%20Admin%20Pekerta,%20saya%20butuh%20bantuan.");
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pastikan WhatsApp terinstal di HP kamu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primaryNavy,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryNavy, Color(0xFF0D1B3E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, top: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Halo, Pekerta Fans!", style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 1)),
                      const SizedBox(height: 5),
                      Text("Mau ke mana\nhari ini?", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.2)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_dateString, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text("Waktu Keberangkatan Real-time", style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  Text(_timeString, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.secondaryOrange, letterSpacing: 1)),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _clickableAction(context, Icons.search_rounded, "Cari Tiket", _showSearchDialog),
                  _clickableAction(context, Icons.confirmation_number_rounded, "E-Tiket", null), 
                  _clickableAction(context, Icons.help_outline_rounded, "Bantuan", _launchWhatsApp),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
              child: Text("Jadwal Kereta Terpopuler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryNavy)),
            ),
          ),

          Consumer<AdminProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) return SliverToBoxAdapter(child: Center(child: Padding(padding: const EdgeInsets.all(40.0), child: CircularProgressIndicator())));
              if (provider.jadwalList.isEmpty) return SliverToBoxAdapter(child: Center(child: Text("Tidak ada jadwal tersedia")));

              return SliverPadding(
                padding: EdgeInsets.only(bottom: 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var item = provider.jadwalList[index];
                      return _buildRailwayTicket(context, item);
                    },
                    childCount: provider.jadwalList.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _clickableAction(BuildContext context, IconData icon, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: AppColors.primaryNavy.withOpacity(0.05), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryNavy, size: 30),
          ),
          SizedBox(height: 12),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildRailwayTicket(BuildContext context, Map item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/detail-jadwal', arguments: item),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['nama_kereta'] ?? 'KAI Express', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryNavy)),
                    Text(AppHelpers.formatRupiah(int.tryParse(item['harga'].toString()) ?? 0), 
                      style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.w900)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stationDetail(item['waktu_berangkat'] ?? '--:--', item['stasiun_asal'] ?? 'Origin', CrossAxisAlignment.start),
                      Icon(Icons.swap_horiz, color: Colors.grey[300]),
                      _stationDetail(item['waktu_tiba'] ?? '--:--', item['stasiun_tujuan'] ?? 'Dest', CrossAxisAlignment.end),
                    ],
                  ),
                ),
              ],
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
        Text(time, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        Text(station, style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
      ],
    );
  }
}