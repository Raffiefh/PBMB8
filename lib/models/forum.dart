class ForumModel {
  final int id;
  final String username;
  final String pesan;
  final DateTime createdAt;
  // final String tanggal;
  // final String waktu;

  ForumModel({
    required this.id,
    required this.username,
    required this.pesan,
    required this.createdAt,
    // required this.tanggal,
    // required this.waktu,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      id: json['id'],
      username: json['username'],
      pesan: json['pesan'],
      createdAt: DateTime.parse(json['created_at']),
      // tanggal: json['tanggal'],
      // waktu: json['waktu'],
    );
  }
  String get waktu =>
    "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

  // Map<String, dynamic> toJson() {
  //   return {
  //     'username': username,
  //     'pesan': pesan,
  //     'created_at': createdAt.toIso8601String(),
  //     'tanggal': tanggal,
  //     'waktu': waktu,
  //   };
  // }
}
