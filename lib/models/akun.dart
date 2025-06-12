class Akun {
  int? id;
  final String username;
  final String nama;
  final String email;
  final String noHp;
  final int roleAkunId;
  String? password;
  

  Akun({
    this.id,
    required this.username,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.roleAkunId,
    this.password
  });

 factory Akun.fromJson(Map<String, dynamic> json) {
  return Akun(
    id: json['id']?.toInt() ?? 0,               // Handle null dan konversi tipe
    username: json['username']?.toString() ?? '',
    noHp: json['no_hp']?.toString() ?? '',
    nama: json['nama']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    roleAkunId: json['role_akun']?.toInt() ?? 0,
    password: json['password']?.toString() ?? '',
  );
}
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'nama': nama,
        'email': email,
        'no_hp': noHp,
        'role_akun': roleAkunId,
        'password': password
      };
}
