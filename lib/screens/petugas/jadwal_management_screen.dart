import 'package:flutter/material.dart';

class JadwalManagementScreen extends StatefulWidget {
  const JadwalManagementScreen({super.key});

  @override
  _JadwalManagementScreenState createState() => _JadwalManagementScreenState();
}

class _JadwalManagementScreenState extends State<JadwalManagementScreen> {
  List<Map<String, dynamic>> jadwalList = [
    {"kereta": "Argo Wilis", "rute": "Bandung - Surabaya", "harga": 450000},
  ];

  void _tambahJadwal() {
    // Di sini kamu bisa buat form popup seperti CRUD Kereta sebelumnya
    // Masukkan input: Nama Kereta, Rute, Jam, dan Harga
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kelola Jadwal"), backgroundColor: Colors.red[900]),
      body: ListView.builder(
        itemCount: jadwalList.length,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            title: Text(jadwalList[i]['kereta']),
            subtitle: Text("${jadwalList[i]['rute']} \nRp ${jadwalList[i]['harga']}"),
            isThreeLine: true,
            trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {}),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahJadwal,
        backgroundColor: Colors.red[900],
        child: Icon(Icons.add),
      ),
    );
  }
}