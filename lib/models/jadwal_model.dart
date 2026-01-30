class JadwalModel {
  final String id, namaKereta, asal, tujuan, jam, harga;

  JadwalModel({required this.id, required this.namaKereta, required this.asal, required this.tujuan, required this.jam, required this.harga});

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      id: json['id_jadwal'].toString(),
      namaKereta: json['nama_kereta'],
      asal: json['stasiun_asal'],
      tujuan: json['stasiun_tujuan'],
      jam: json['waktu_berangkat'],
      harga: json['harga_tiket'].toString(),
    );
  }
}