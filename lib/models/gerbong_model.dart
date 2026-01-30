class GerbongModel {
  final String id;
  final String namaGerbong;
  final String idKereta;

  GerbongModel({required this.id, required this.namaGerbong, required this.idKereta});

  factory GerbongModel.fromJson(Map<String, dynamic> json) {
    return GerbongModel(
      id: json['id_gerbong'].toString(),
      namaGerbong: json['nama_gerbong'],
      idKereta: json['id_kereta'].toString(),
    );
  }
}