import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbmuas/const/api_url.dart' as url;
import 'package:pbmuas/models/akun.dart';

class AuthService {
  final String apiUrl = '${url.baseUlr}/auth';

  Future<String?> login(String username, String password) async {
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
        return data['access_token']; 
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

  Future<bool> register(Akun akun) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(akun.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }

   Future<bool> updateAkun(Akun akun) async{
    final response = await http.put(Uri.parse('$apiUrl/profile/${akun.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(akun.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }
}
