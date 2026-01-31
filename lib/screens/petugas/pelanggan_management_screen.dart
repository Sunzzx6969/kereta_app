import 'package:flutter/material.dart';

class PelangganManagementScreen extends StatelessWidget {
  const PelangganManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Data Pelanggan"),
        backgroundColor: Colors.red[900],
      ),
      body: ListView.builder(
        itemCount: 5, // Ganti dengan data dari API nanti
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.blue[900], child: Icon(Icons.person, color: Colors.white)),
            title: Text("Nama Pelanggan $index"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("NIK: 32010023000$index"),
                Text("Telp: 081234567$index"),
              ],
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Logika Hapus Pelanggan
              },
            ),
          ),
        ),
      ),
    );
  }
}