import 'package:intl/intl.dart';

class ForumModel {
  final int id;
  final String username;
  final String pesan;
  final DateTime createdAt;

  ForumModel({
    required this.id,
    required this.username,
    required this.pesan,
    required this.createdAt,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    String createdAtString = json['created_at'];
    return ForumModel(
      id: json['id'],
      username: json['username'],
      pesan: json['pesan'],
      createdAt: DateTime.parse(createdAtString).toLocal(), 
    );
  }

  String get waktuFormatted => DateFormat('HH:mm').format(createdAt);

 
  String get tanggalFormatted =>
      DateFormat('dd MMMM yyyy', 'id_ID').format(createdAt);
}
