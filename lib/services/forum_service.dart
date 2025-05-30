import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pbmuas/const/api_url.dart' as url;
import 'package:pbmuas/models/forum.dart';
import 'package:pbmuas/helpers/session_helper.dart';

class ForumService {
  final supabase = Supabase.instance.client;

  Future<void> kirimPesan(int akunId, String pesan, String username) async {
    await supabase.from('forum').insert({
      'akun_id': akunId,
      'username': username,
      'pesan': pesan,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Stream<List<Map<String, dynamic>>> ambilPesan() {
    return supabase
        .from('forum')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .limit(100);
  }

  // Future<Map<String, String>> _getHeaders() async {
  //   final token = await SessionHelper.getToken();
  //   return {
  //     'Content-Type': 'application/json',
  //     if (token != null) 'Authorization': 'Bearer $token',
  //   };
  // }

  // Future<List<ForumMessage>> fetchMessages() async {
  //   final headers = await _getHeaders();
  //   final response = await http.get(
  //     Uri.parse('$apiUrl/pesan'),
  //     headers: headers,
  //   );
  //   if (response.statusCode == 200) {
  //     List jsonData = json.decode(response.body);
  //     return jsonData.map((e) => ForumMessage.fromJson(e)).toList();
  //   }
  //   if (response.statusCode == 403) {
  //     throw Exception('butuh token jwt');
  //   } else {
  //     throw Exception('Gagal memuat pesan forum');
  //   }
  // }

  // Future<void> sendMessage(ForumMessage message) async {
  //   final headers = await _getHeaders();
  //   final response = await http.post(
  //     Uri.parse('$apiUrl/pesan'),
  //     headers: headers,
  //     body: json.encode(message.toJson()),
  //   );

  //   if (response.statusCode != 200 && response.statusCode != 201) {
  //     throw Exception('Gagal mengirim pesan');
  //   }
  // }
}
