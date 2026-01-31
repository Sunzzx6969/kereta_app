import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class GerbongManagementScreen extends StatefulWidget {
  const GerbongManagementScreen({super.key});

  @override
  _GerbongManagementScreenState createState() => _GerbongManagementScreenState();
}

class _GerbongManagementScreenState extends State<GerbongManagementScreen> {
  // Data Dummy Gerbong
  List<Map<String, String>> listGerbong = [
    {"nama": "Eks-1", "kereta": "Argo Bromo"},
    {"nama": "Eks-2", "kereta": "Argo Bromo"},
    {"nama": "Eko-1", "kereta": "Matarmaja"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Gerbong"),
        backgroundColor: Colors.red[900], // Warna khas Petugas/Admin
      ),
      body: ListView.builder(
        itemCount: listGerbong.length,
        itemBuilder: (context, i) => Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.directions_railway, color: AppColors.primaryNavy),
            title: Text("Gerbong ${listGerbong[i]['nama']}"),
            subtitle: Text("Kereta: ${listGerbong[i]['kereta']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red[900],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}