class KursiModel {
  final String id, nomorKursi, status;

  KursiModel({required this.id, required this.nomorKursi, required this.status});

  factory KursiModel.fromJson(Map<String, dynamic> json) {
    return KursiModel(
      id: json['id_kursi'].toString(),
      nomorKursi: json['nomor_kursi'],
      status: json['status'], // tersedia / dipesan
    );
  }
}