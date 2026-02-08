// import 'package:flutter/material.dart';
// import '../../utils/colors.dart';

// class PetugasManagementScreen extends StatefulWidget {
//   const PetugasManagementScreen({super.key});

//   @override
//   State<PetugasManagementScreen> createState() => _PetugasManagementScreenState();
// }

// class _PetugasManagementScreenState extends State<PetugasManagementScreen> {
//   // Simulasi data petugas
//   List<Map<String, String>> listPetugas = [
//     {"nama": "Sultan Admin", "username": "sultan_kai", "role": "Admin"},
//     {"nama": "Budi Santoso", "username": "budi_petugas", "role": "Petugas"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         title: const Text("MANAJEMEN PETUGAS", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: AppColors.primaryNavy,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: listPetugas.length,
//         itemBuilder: (context, index) {
//           final petugas = listPetugas[index];
//           return Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             margin: const EdgeInsets.only(bottom: 15),
//             child: ListTile(
//               leading: const CircleAvatar(
//                 backgroundColor: AppColors.primaryNavy,
//                 child: Icon(Icons.badge, color: Colors.white, size: 20),
//               ),
//               title: Text(petugas['nama']!, style: const TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Text("${petugas['username']} • ${petugas['role']}"),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 onPressed: () {
//                   setState(() => listPetugas.removeAt(index));
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.secondaryOrange,
//         onPressed: () => _showAddPetugasDialog(context),
//         child: const Icon(Icons.person_add, color: Colors.white),
//       ),
//     );
//   }

//   void _showAddPetugasDialog(BuildContext context) {
//     final nameCtrl = TextEditingController();
//     final userCtrl = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Tambah Petugas Baru"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nama Lengkap")),
//             TextField(controller: userCtrl, decoration: const InputDecoration(labelText: "Username")),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNavy),
//             onPressed: () {
//               setState(() {
//                 listPetugas.add({
//                   "nama": nameCtrl.text,
//                   "username": userCtrl.text,
//                   "role": "Petugas"
//                 });
//               });
//               Navigator.pop(context);
//             },
//             child: const Text("Simpan", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }