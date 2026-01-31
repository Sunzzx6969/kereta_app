import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../utils/colors.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;
    final Map jadwal = args?['jadwal'] ?? {};
    final Map kursi = args?['kursi'] ?? {};

    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      appBar: AppBar(
        title: const Text("E-Tiket", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // UI TIKET (Tetap sama agar tampilan di aplikasi cantik)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                children: [
                  _buildQrSection(jadwal),
                  _buildDashedLine(),
                  _buildTicketDetails(jadwal, kursi),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // TOMBOL DOWNLOAD PDF
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton.icon(
                onPressed: () => _generatePdf(jadwal, kursi), // Panggil Fungsi PDF
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text("DOWNLOAD PDF TIKET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryOrange,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI GENERATE PDF ---
  Future<void> _generatePdf(Map jadwal, Map kursi) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6, // Ukuran pas untuk tiket
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text("SULTAN TRAIN TICKET", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _pdfRow("ID Tiket", "TRX-${jadwal['id'] ?? '000'}"),
              _pdfRow("Kereta", jadwal['nama_kereta']?.toString() ?? "-"),
              _pdfRow("Dari", jadwal['asal_keberangkatan']?.toString() ?? "-"),
              _pdfRow("Ke", jadwal['tujuan_keberangkatan']?.toString() ?? "-"),
              _pdfRow("Gerbong", "G${kursi['gerbong_pilihan'] ?? "-"}"),
              _pdfRow("Kursi", kursi['seat_label']?.toString() ?? "-"),
              _pdfRow("Tanggal", jadwal['tanggal_berangkat']?.toString() ?? "-"),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text("Simpan PDF ini untuk ditunjukkan saat boarding.", 
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey))
              ),
            ],
          );
        },
      ),
    );

    // Langsung buka preview/print dialog
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10)),
          pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  // ... (Widget UI Aplikasi: _buildQrSection, _buildDashedLine, _buildTicketDetails tetap sama)
  Widget _buildQrSection(Map jadwal) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text("TUNJUKKAN QR CODE INI SAAT BOARDING", 
            style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.qr_code_2_rounded, size: 180, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 15),
          Text("TRX-${jadwal['id']?.toString() ?? "9928172"}", style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Row(children: List.generate(20, (index) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: index.isEven ? Colors.transparent : Colors.grey[300]))));
  }

  Widget _buildTicketDetails(Map jadwal, Map kursi) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ticketItem("NAMA KERETA", jadwal['nama_kereta']?.toString() ?? "-", CrossAxisAlignment.start),
              _ticketItem("KELAS", jadwal['kelas']?.toString() ?? "Eksekutif", CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ticketItem("DARI", jadwal['asal_keberangkatan']?.toString() ?? "-", CrossAxisAlignment.start),
              Icon(Icons.train, size: 18, color: AppColors.secondaryOrange),
              _ticketItem("KE", jadwal['tujuan_keberangkatan']?.toString() ?? "-", CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ticketItem("TANGGAL", (jadwal['tanggal_berangkat']?.toString() ?? "-").split(' ')[0], CrossAxisAlignment.start),
              _ticketItem("GERBONG", "G${kursi['gerbong_pilihan'] ?? "-"}", CrossAxisAlignment.center),
              _ticketItem("KURSI", kursi['seat_label']?.toString() ?? "-", CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ticketItem(String label, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}