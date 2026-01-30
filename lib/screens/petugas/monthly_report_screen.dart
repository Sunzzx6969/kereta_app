import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';

class MonthlyReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laporan Penjualan"), backgroundColor: Colors.red[900]),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.red[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Pendapatan:", style: TextStyle(fontSize: 16)),
                Text(AppHelpers.formatRupiah(15000000), 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red[900])),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, i) => ListTile(
                leading: CircleAvatar(child: Text("${i+1}")),
                title: Text("Transaksi #TRX00${i+1}"),
                subtitle: Text("Pelanggan: Hana"),
                trailing: Text(AppHelpers.formatRupiah(500000)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}