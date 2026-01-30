class UserModel {
  final String userId;
  final String role;
  final String nik;
  final String namaLengkap;
  final String alamat;
  final String telp;

  UserModel({
    required this.userId,
    required this.role,
    required this.nik,
    required this.namaLengkap,
    required this.alamat,
    required this.telp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Kita ambil bagian 'data' dari JSON API
    var data = json['data'] ?? {};
    var profile = data['profile'] ?? {};

    return UserModel(
      // Gunakan .toString() dan ?? agar tidak error jika data null
      userId: data['user_id']?.toString() ?? '0',
      role: data['role']?.toString() ?? 'penumpang',
      nik: profile['nik']?.toString() ?? '-',
      
      // LOGIKA PENTING: Cek nama_petugas dulu, kalau kosong ambil nama_penumpang
      namaLengkap: profile['nama_petugas']?.toString() ?? 
                   profile['nama_penumpang']?.toString() ?? 
                   'Nama Tidak Terdaftar',
      
      alamat: profile['alamat']?.toString() ?? '-',
      telp: profile['telp']?.toString() ?? '-',
    );
  }
}