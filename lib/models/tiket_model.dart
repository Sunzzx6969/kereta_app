class TiketModel {
  final String idTiket, namaPenumpang, rute, totalBayar, tgl;

  TiketModel({required this.idTiket, required this.namaPenumpang, required this.rute, required this.totalBayar, required this.tgl});

  factory TiketModel.fromJson(Map<String, dynamic> json) {
    return TiketModel(
      idTiket: json['id_tiket'].toString(),
      namaPenumpang: json['nama_penumpang'],
      rute: "${json['asal']} - ${json['tujuan']}",
      totalBayar: json['total'].toString(),
      tgl: json['tanggal'],
    );
  }
}