class KeretaModel {
  final String id, namaKereta, deskripsi;

  KeretaModel({required this.id, required this.namaKereta, required this.deskripsi});

  factory KeretaModel.fromJson(Map<String, dynamic> json) {
    return KeretaModel(
      id: json['id_kereta'].toString(),
      namaKereta: json['nama_kereta'],
      deskripsi: json['deskripsi'] ?? "",
    );
  }
}