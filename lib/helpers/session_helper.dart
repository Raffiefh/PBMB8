import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pbmuas/models/akun.dart';

class SessionHelper {
  static const _tokenKey = 'jwt_token';
  static const _staySignedKey = 'stay_signed';
  static const _userKey = 'user_data';

 static Future<void> saveUserSession(String token, Akun akun, bool staySigned) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Validasi data sebelum menyimpan
    if (token.isEmpty || akun.id == null) {
      throw Exception('Data session tidak valid');
    }
    
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_staySignedKey, staySigned);
    
    final userJson = jsonEncode(akun.toJson());
    if (userJson.isEmpty) {
      throw Exception('Gagal encode data user');
    }
    
    await prefs.setString(_userKey, userJson);
    print('Session berhasil disimpan');
  } catch (e) {
    print('Gagal menyimpan session: $e');
    rethrow; // Lempar exception ke caller
  }
}

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Akun?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString(_userKey);
  print('=== GET USER ===');
  print('userJson: $userJson'); // Tambahkan log ini
  if (userJson == null) return null;

  try {
    final map = jsonDecode(userJson);
    return Akun.fromJson(map);
  } catch (e) {
    print('Gagal decode user: $e');
    return null;
  }
}

  static Future<void> updateUser(Akun akun) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(akun.toJson()));
  }



  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  static Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_tokenKey);
  await prefs.remove(_staySignedKey);
  await prefs.remove(_userKey);
  print('=== LOGOUT ===');
  print('Session dihapus');
}
}