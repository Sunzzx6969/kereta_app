import 'package:flutter/material.dart';

class KeretaManagementScreen extends StatefulWidget {
  const KeretaManagementScreen({super.key});

  @override
  _KeretaManagementScreenState createState() => _KeretaManagementScreenState();
}

class _KeretaManagementScreenState extends State<KeretaManagementScreen> {
  // Data dummy untuk list kereta
  List<Map<String, String>> listKereta = [
    {"nama": "Argo Bromo", "tipe": "Eksekutif"},
    {"nama": "Matarmaja", "tipe": "Ekonomi"},
  ];

  void _showForm(int? index) {
    TextEditingController namaCtrl = TextEditingController(text: index != null ? listKereta[index]['nama'] : "");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? "Tambah Kereta" : "Edit Kereta"),
        content: TextField(controller: namaCtrl, decoration: InputDecoration(labelText: "Nama Kereta")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (index == null) {
                  listKereta.add({"nama": namaCtrl.text, "tipe": "Eksekutif"});
                } else {
                  listKereta[index]['nama'] = namaCtrl.text;
                }
              });
              Navigator.pop(context);
            }, 
            child: Text("Simpan")
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kelola Data Kereta"), backgroundColor: Colors.blue[900]),
      body: ListView.builder(
        itemCount: listKereta.length,
        itemBuilder: (context, i) => ListTile(
          leading: Icon(Icons.train),
          title: Text(listKereta[i]['nama']!),
          subtitle: Text(listKereta[i]['tipe']!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(i)),
              IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => listKereta.removeAt(i))),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}