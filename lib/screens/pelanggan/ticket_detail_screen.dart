import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../utils/colors.dart';

class TicketDetailScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  final String paymentMethod;

  const TicketDetailScreen({super.key, required this.bookingData, required this.paymentMethod});

  // --- FUNGSI DOWNLOAD PDF (DIBUAT PUTIH BERSIH) ---
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    final item = bookingData;
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    
    String harga = fmt.format(int.tryParse((item['total_harga'] ?? item['harga'] ?? '0').toString()) ?? 0);
    String kode = (item['id_booking'] ?? 'BK-OFFLINE').toString();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("E-TIKET KERETA", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text("PEKERTA INDONESIA", style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 20),
                pw.Text("Nama Kereta: ${item['nama_kereta'] ?? 'KAI'}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text("Kode Booking: $kode"),
                pw.SizedBox(height: 30),
                pw.Center(
                  child: pw.Container(width: 150, height: 150, child: pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: kode)),
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                _pdfRow("Nama Penumpang", (item['nama_penumpang'] ?? 'User').toString()),
                _pdfRow("Jadwal Berangkat", (item['tanggal_berangkat'] ?? '-').toString()),
                _pdfRow("Rute", "${item['asal'] ?? 'JKT'} -> ${item['tujuan'] ?? 'SBY'}"),
                _pdfRow("Gerbong/Kursi", "${item['nama_gerbong']} / ${item['no_kursi']}"),
                _pdfRow("Status", "LUNAS"),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Total Bayar", style: pw.TextStyle(fontSize: 14)),
                    pw.Text(harga, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Buka Preview & Download
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(label), pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = bookingData;
    final fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    String harga = fmt.format(int.tryParse((item['total_harga'] ?? item['harga'] ?? '0').toString()) ?? 0);
    String kode = (item['id_booking'] ?? 'BK-OFFLINE').toString();

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("E-Tiket Kereta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst)),
      ),
      body: Stack(
        children: [
          // Background Biru Glassmorphism (Sesuai Permintaan)
          Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0A1330), AppColors.primaryNavy, Color(0xFF15264F)])))),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // CARD TIKET GLASS
                  _glass(
                    child: Column(
                      children: [
                        const Text("E-TIKET RESMI", style: TextStyle(color: AppColors.secondaryOrange, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const Divider(color: Colors.white10, height: 30),
                        
                        // Header Tiket
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item['nama_kereta'] ?? 'Sriwijaya', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            Text("ID: $kode", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                          ]),
                          const Icon(Icons.train, color: Colors.white24, size: 40),
                        ]),

                        // QR Code
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: QrImageView(data: kode, version: QrVersions.auto, size: 160.0),
                          ),
                        ),

                        // Detail Info Rapi
                        _infoRow("Nama", item['nama_penumpang'] ?? 'User'),
                        _infoRow("Rute", "${item['asal'] ?? 'JKT'} ➝ ${item['tujuan'] ?? 'SBY'}", valColor: AppColors.secondaryOrange),
                        _infoRow("Kursi", "${item['nama_gerbong']} / ${item['no_kursi']}"),
                        _infoRow("Waktu", item['tanggal_berangkat'] ?? '-'),
                        
                        const Divider(color: Colors.white24, height: 40),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text("Total Bayar", style: TextStyle(color: Colors.white54)),
                          Text(harga, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // TOMBOL DOWNLOAD PDF
                  SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () => _generatePdf(context),
                      icon: const Icon(Icons.picture_as_pdf, color: AppColors.primaryNavy),
                      label: const Text("SIMPAN E-TIKET (PDF)", style: TextStyle(color: AppColors.primaryNavy, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glass({required Widget child}) => ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(30)),
        child: child,
      ),
    ),
  );

  Widget _infoRow(String l, String v, {Color? valColor}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(color: Colors.white38, fontSize: 13)),
      Text(v, style: TextStyle(color: valColor ?? Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    ]),
  );
}