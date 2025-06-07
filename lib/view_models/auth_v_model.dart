import 'package:flutter/material.dart';
import 'package:pbmuas/models/akun.dart';
import 'package:pbmuas/services/auth_service.dart';
import 'package:pbmuas/helpers/session_helper.dart';
import 'package:jwt_decode/jwt_decode.dart';
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
    final token = await _service.login(username, password);
    if (token == null) {
      print('Token null dari service');
      _isLoading = false;
      notifyListeners();
      return false;
    }
    
    final payload = Jwt.parseJwt(token);
    print('Payload JWT: $payload');

    // Validasi payload penting
    if (payload['id'] == null || payload['role_akun_id'] == null) {
      print('Payload tidak lengkap');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final akun = Akun(
      id: payload['id'] as int,
      username: username,
      nama: payload['nama']?.toString() ?? '',
      noHp: payload['no_hp']?.toString() ?? '',
      email: payload['email']?.toString() ?? '',
      roleAkunId: payload['role_akun_id'] as int,
    );
    
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
    return true; // Pastikan return true jika semua sukses
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

  Future<bool> register(Akun akun) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _service.register(akun);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String username, String nama, String email, String noHp) async{
    if(akun == null) return false;
    _isLoading = true;
    notifyListeners();

    try{
      final updatedAkun = Akun(
        id: akun!.id, 
        username: username, 
        nama: nama, 
        email: email, 
        noHp: noHp,
        // password: akun!.password, 
        roleAkunId: akun!.roleAkunId
      );
      
      final updated = await _service.updateAkun(updatedAkun);
      if(updated) {
        _akun = updatedAkun;
        await SessionHelper.updateUser(_akun!);
      }
      return updated;
    }catch(e){
      print("Update profile failed: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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