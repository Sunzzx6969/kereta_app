import 'package:flutter/material.dart';

class KursiManagementScreen extends StatefulWidget {
  @override
  _KursiManagementScreenState createState() => _KursiManagementScreenState();
}

class _KursiManagementScreenState extends State<KursiManagementScreen> {
  // Data dummy kursi (tersedia/terisi)
  List<Map<String, dynamic>> kursiList = List.generate(20, (index) => {
    "nomor": "${(index / 4).floor() + 1}${String.fromCharCode(65 + (index % 4))}",
    "is_available": true
  });

  void _toggleKursi(int index) {
    setState(() {
      kursiList[index]['is_available'] = !kursiList[index]['is_available'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kelola Kursi"), backgroundColor: Colors.red[900]),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, 
          mainAxisSpacing: 10, 
          crossAxisSpacing: 10
        ),
        itemCount: kursiList.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () => _toggleKursi(i),
          child: Container(
            decoration: BoxDecoration(
              color: kursiList[i]['is_available'] ? Colors.green[100] : Colors.red[100],
              border: Border.all(color: kursiList[i]['is_available'] ? Colors.green : Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                kursiList[i]['nomor'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        child: Text("* Klik kursi untuk mengubah status (Tersedia/Penuh)", 
                   textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic)),
      ),
    );
  }
}