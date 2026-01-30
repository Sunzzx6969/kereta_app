import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Petugas"),
        backgroundColor: Colors.red[900], // Warna beda supaya ketahuan ini Admin
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => Navigator.pushReplacementNamed(context, '/login')),
        ],
      ),
      body: GridView.count(
        padding: EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _adminCard(context, "Data Kereta", Icons.train, Colors.blue),
          _adminCard(context, "Jadwal", Icons.calendar_today, Colors.orange),
          _adminCard(context, "User/Penumpang", Icons.people, Colors.green),
          _adminCard(context, "Laporan", Icons.summarize, Colors.purple, route: '/report'),
        ],
      ),
    );
  }

  Widget _adminCard(BuildContext context, String title, IconData icon, Color color, {String route = '/home'}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}