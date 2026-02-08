import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../utils/colors.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  List<dynamic> _gerbongs = [];
  String? _selG, _selKNo, _selGNama;
  bool _isBooking = false, _isInit = false;

  @override
  void initState() {
    super.initState();
    final u = Provider.of<AuthProvider>(context, listen: false).user;
    if (u != null) {
      _namaController.text = u.nama;
      _nikController.text = (u.nik == '-' || u.nik == null) ? '' : u.nik!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _initFetch();
      _isInit = true;
    }
  }

  void _initFetch() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args == null) return;
    final data = await Provider.of<BookingProvider>(context, listen: false)
        .getGerbong((args['id_kereta'] ?? args['id_armada'] ?? '1').toString());
    if (mounted && data.isNotEmpty) {
      setState(() {
        _gerbongs = data;
        _selG = null;
        _selGNama = null;
      });
    }
  }

  String _getTime(String? dateTime) {
    if (dateTime == null || dateTime.length < 16) return "--:--";
    return dateTime.substring(11, 16);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String asal = (args['asal'] ?? args['asal_keberangkatan'] ?? 'ASAL').toString();
    String tujuan = (args['tujuan'] ?? args['tujuan_keberangkatan'] ?? 'TUJUAN').toString();
    String tglB = (args['tanggal_berangkat'] ?? '2026-01-01 00:00:00').toString();
    String tglT = (args['tanggal_kedatangan'] ?? '2026-01-01 00:00:00').toString();

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Detail Pemesanan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1330), AppColors.primaryNavy])))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _glass(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(args['nama_kereta'] ?? 'Sriwijaya', style: const TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("Rp ${args['harga']}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _col(_getTime(tglB), asal.toUpperCase(), CrossAxisAlignment.start),
                            const Icon(Icons.train, color: AppColors.secondaryOrange, size: 28),
                            _col(_getTime(tglT), tujuan.toUpperCase(), CrossAxisAlignment.end),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _label("Data Penumpang"),
                  _input("Nama Lengkap", _namaController, Icons.person),
                  _input("NIK", _nikController, Icons.badge, isNum: true),
                  const SizedBox(height: 25),
                  _label("Pilih Kursi"),
                  GestureDetector(
                    onTap: () => _showSeatPopup(args),
                    child: _glass(
                      opacity: 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.airline_seat_recline_normal, color: AppColors.secondaryOrange),
                              const SizedBox(width: 15),
                              Text(
                                (_selKNo == null || _selGNama == null)
                                    ? "Klik untuk pilih kursi"
                                    : "$_selGNama - Kursi $_selKNo",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.primaryNavy.withOpacity(0.8)])),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: _isBooking ? null : () async {
                    if (_selKNo == null || _selGNama == null || _namaController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lengkapi Nama & Pilih Kursi!")));
                      return;
                    }
                    setState(() => _isBooking = true);
                    final res = await Provider.of<BookingProvider>(context, listen: false).createBooking(
                      rawData: {
                        'nama_kereta': args['nama_kereta'],
                        'asal': asal, 'tujuan': tujuan, 'harga': args['harga'],
                        'nama_penumpang': _namaController.text, 'no_kursi': _selKNo,
                        'nama_gerbong': _selGNama, 'tanggal_berangkat': tglB,
                      },
                    );
                    setState(() => _isBooking = false);
                    if (res['success']) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => PaymentScreen(bookingData: {
                          'id_booking': res['id_booking'], 'nama_kereta': args['nama_kereta'],
                          'total_harga': args['harga'], 'nama_penumpang': _namaController.text,
                          'no_kursi': _selKNo, 'nama_gerbong': _selGNama,
                          'asal': asal, 'tujuan': tujuan, 'tanggal_berangkat': tglB,
                        })),
                      );
                    }
                  },
                  child: _isBooking ? const CircularProgressIndicator(color: Colors.white) : const Text("LANJUT KE PEMBAYARAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSeatPopup(Map<String, dynamic> args) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setM) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(color: Color(0xFF0A1330), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // --- LABEL DINAMIS: G1 - K4 --- [cite: 2026-01-30]
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(color: AppColors.secondaryOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.secondaryOrange.withOpacity(0.5))),
                child: Text(
                  "Pilihan Anda: ${_selGNama ?? '--'} - Kursi ${_selKNo ?? '--'}",
                  style: const TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 25),
              const Text("Pilih Gerbong", style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 10),
              if (_gerbongs.isNotEmpty)
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _gerbongs.length,
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: () {
                          setM(() {
                            _selG = _gerbongs[i]['id_gerbong'].toString();
                            _selGNama = _gerbongs[i]['nama_gerbong'].toString();
                          });
                          setState(() {
                            _selG = _gerbongs[i]['id_gerbong'].toString();
                            _selGNama = _gerbongs[i]['nama_gerbong'].toString();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // SEMUA TETAP GELAP AGAR TIDAK BINGUNG [cite: 2026-01-30]
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text("${_gerbongs[i]['nama_gerbong']}", style: const TextStyle(color: Colors.white38)),
                        ),
                      );
                    },
                  ),
                ),
              const Divider(color: Colors.white10, height: 40),
              const Text("Pilih Nomor Kursi", style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
                  itemCount: 40,
                  itemBuilder: (ctx, i) {
                    final String no = (i + 1).toString();
                    bool isS = _selKNo == no;
                    return GestureDetector(
                      onTap: () { setM(() => _selKNo = no); setState(() => _selKNo = no); },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isS ? AppColors.secondaryOrange : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(no, style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () => Navigator.pop(context), child: const Text("KONFIRMASI PILIHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _glass({required Widget child, double opacity = 0.1}) => ClipRRect(borderRadius: BorderRadius.circular(25), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(opacity), border: Border.all(color: Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(25)), child: child)));
  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 10, left: 5), child: Text(t, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)));
  Widget _col(String t, String c, CrossAxisAlignment a) => Column(crossAxisAlignment: a, children: [Text(t, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), Text(c, style: const TextStyle(color: Colors.white54, fontSize: 12))]);
  Widget _input(String h, TextEditingController c, IconData i, {bool isNum = false}) => Container(margin: const EdgeInsets.only(bottom: 15), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)), child: TextField(controller: c, keyboardType: isNum ? TextInputType.number : TextInputType.text, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white24), prefixIcon: Icon(i, color: AppColors.secondaryOrange), border: InputBorder.none, contentPadding: const EdgeInsets.all(18))));
}