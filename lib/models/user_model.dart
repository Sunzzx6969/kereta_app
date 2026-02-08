class UserModel {
  final String id;
  final String username;
  final String nama;
  final String role;
  final String? token;
  final String? nik, telp, alamat, fotoProfil;

  UserModel({
    required this.id,
    required this.username,
    required this.nama,
    required this.role,
    this.token,
    this.nik,
    this.telp,
    this.alamat,
    this.fotoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Normalisasi: API kamu kadang bungkus di 'data', kadang langsung
    Map<String, dynamic> dataUtama = json['data'] ?? json;
    Map<String, dynamic> dataProfile = dataUtama['profile'] ?? {};

    return UserModel(
      // Ambil ID dari user_id (API Asli) atau id (Dummy/Lainnya)
      id: (dataUtama['user_id'] ?? dataUtama['id'])?.toString() ?? '0',
      username: dataUtama['username']?.toString() ?? '',
      nama: (dataProfile['nama_penumpang'] ?? dataProfile['nama_petugas'] ?? dataUtama['nama'] ?? 'User').toString(),
      role: (dataUtama['role'] ?? 'pelanggan').toString(),
      token: json['token']?.toString(),
      nik: dataProfile['nik']?.toString(),
      telp: dataProfile['telp']?.toString(),
      alamat: dataProfile['alamat']?.toString(),
      fotoProfil: dataProfile['foto'] ?? dataUtama['foto'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'username': username, 'nama': nama, 'role': role,
    'token': token, 'nik': nik, 'telp': telp, 'alamat': alamat, 'foto': fotoProfil,
  };
}