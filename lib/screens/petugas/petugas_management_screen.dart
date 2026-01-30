import 'package:flutter/material.dart';

class PetugasManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Data Petugas"),
        backgroundColor: Colors.red[900],
      ),
      body: ListView.builder(
        itemCount: 3, 
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.orange[800], child: Icon(Icons.admin_panel_settings, color: Colors.white)),
            title: Text("Petugas Staff $index"),
            subtitle: Text("ID Petugas: PTG-00$index"),
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
        child: Icon(Icons.add),
      ),
    );
  }
}