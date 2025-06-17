import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pbmuas/const/api_url.dart' as url;
import 'package:pbmuas/models/akun.dart';
import 'package:pbmuas/helpers/session_helper.dart';

class AuthService {
  final String apiUrl = '${url.baseUlr}/auth';
  Future<Map<String, String>> _getHeaders() async {
    final token = await SessionHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final payload = {'username': username, 'password': password};

      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        print('Login gagal: ${errorData['detail']}');
        return null;
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return null;
    }
  }

  Future<String?> register(Akun akun) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(akun.toJson()),
      );
      if (response.statusCode == 200) {
        return null;
      } else if (response.statusCode == 400) {
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          if (errorData.containsKey('detail') &&
              errorData['detail'] is String) {
            return errorData['detail'];
          } else {
            return 'Pendaftaran gagal: Format respons error tidak dikenal.';
          }
        } catch (e) {
          return 'Pendaftaran gagal: ${response.body}';
        }
      } else {
        // Menangani status code HTTP lainnya (misalnya 500 Internal Server Error, 404 Not Found)
        print(
          'Error during registration: ${response.statusCode} - ${response.body}',
        );
        return 'Pendaftaran gagal. Terjadi kesalahan server (${response.statusCode}).';
      }
    } catch (e) {
      print('Exception during registration: $e');
      return 'Terjadi kesalahan jaringan. Pastikan Anda terhubung ke internet dan Url';
    }
  }

  Future<Map<String, dynamic>?> updateAkun(Akun akun) async {
    final response = await http.put(
      Uri.parse('$apiUrl/profile/${akun.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(akun.toJson()),
    );

    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // return full response yang termasuk token dan akun baru
    } else {
      print('Update error: ${response.body}');
      return null;
    }
  }
  
  Future<String?> uploadFoto(int id, File foto) async{
    final headers = await _getHeaders();
    final request = http.MultipartRequest(
      'PUT',
       Uri.parse('$apiUrl/foto/$id'));
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    request.headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final json = jsonDecode(respStr);
      return json['profil_url'];
    } else {
      print('Upload foto gagal: ${response.statusCode}');
      return null;
    }
  }
}
