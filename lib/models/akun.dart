class Akun {
  int? id;
  String? username;
  String? nama;
  String? email;
  String? noHp;
  int? roleAkunId;
  String? profilUrl;
  String? password;
  

  Akun({
    this.id,
    this.username,
    this.nama,
    this.email,
    this.noHp,
    this.roleAkunId,
    this.profilUrl,
    this.password
  });

  factory Akun.fromJson(Map<String, dynamic> json) {
    return Akun(
      id: int.tryParse(json['id'].toString()) ?? 0,
      username: json['username']?.toString() ?? '',
      noHp: json['no_hp']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      roleAkunId: int.tryParse(json['role_akun_id'].toString()) ?? 0,
      profilUrl: json['profil_url']?.toString() ?? '',
      password: json['password']?.toString(), 
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'nama': nama,
        'email': email,
        'no_hp': noHp,
        'role_akun_id': roleAkunId,
        'profil_url': profilUrl,
        'password': password
      };
}
