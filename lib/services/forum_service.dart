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
      'created_at': DateTime.now().toLocal().toIso8601String(),
    });
  }

  Stream<List<Map<String, dynamic>>> ambilPesan() {
    return supabase
        .from('forum')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .limit(100);
  }

}
