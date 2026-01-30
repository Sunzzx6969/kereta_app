import 'package:flutter/material.dart';

class TransaksiHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Histori Semua Transaksi"), backgroundColor: Colors.red[900]),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            title: Text("Pemesanan #KAI-00$i"),
            subtitle: Text("Pelanggan: Hana | Kereta: Argo Bromo"),
            trailing: Text("Rp 500.000", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}