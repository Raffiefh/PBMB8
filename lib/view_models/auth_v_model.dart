import 'package:flutter/material.dart';
import 'package:pbmuas/models/akun.dart';
import 'package:pbmuas/services/auth_service.dart';
import 'package:pbmuas/helpers/session_helper.dart';
class AuthVModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Akun? _akun;
  Akun? get akun => _akun;

  Future<bool> login(String username, String password, bool staySigned) async {
  _isLoading = true;
  notifyListeners();

  try {
    final result = await _service.login(username, password);
    if (result == null) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
 
    final token = result['access_token'];
    if (token == null) {
      print('Token tidak ditemukan');
      return false;
    }


    final akun = Akun.fromJson(result);
    _akun = akun;
    print('Akun sebelum save: ${akun.toJson()}');

    try {
      await SessionHelper.saveUserSession(token, akun, staySigned);
      print('Session berhasil disimpan');
    } catch (e) {
      print('Gagal menyimpan session: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true; 
  } catch (e, stackTrace) {
    print('Error pada login: $e');
    print('Stack trace: $stackTrace');
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  Future<void> logout() async {
    _akun = null;
    await SessionHelper.logout();
    notifyListeners();
  }

  Future<void> loadUserFromSession() async {
    final isLogged = await SessionHelper.isLoggedIn();
    if (isLogged) {
      _akun = await SessionHelper.getUser();
      notifyListeners();
    }
  }

  Future<String?> register(Akun akun) async {
    _isLoading = true;
    notifyListeners();
    try {
      // final success = await _service.register(akun);
      final String? errorMessage = await _service.register(akun);
      _isLoading = false;
      notifyListeners();
      return errorMessage;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error in AuthVModel register: $e');
      return 'Terjadi kesalahan tidak terduga saat pendaftaran.';
    }
  }
  Future<bool> updateDataAkun(Akun updated) async {
  _isLoading = true;
  notifyListeners();

  final result = await _service.updateAkun(updated);

  if (result == null) {
    _isLoading = false;
    notifyListeners();
    return false;
  }

  try {
    final newToken = result['access_token'];
    final akunBaru = Akun.fromJson(result);

    _akun = akunBaru;
    await SessionHelper.saveUserSession(newToken, akunBaru, true);
    
    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    print('Gagal memproses data update: $e');
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

   


  int _mapRoleToId(String? role) {
    switch (role) {
      case 'panitia':
        return 1;
      case 'peserta':
        return 2;
      default:
        return 0;
    }
  }
}