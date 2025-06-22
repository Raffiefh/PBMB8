import 'dart:io';

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
    final akunBaru = Akun(
      id: int.tryParse(result['id'].toString()),
      username: result['username'],
      nama: result['nama'],
      email: result['email'],
      noHp: result['no_hp'],
      roleAkunId: int.tryParse(result['role_akun_id'].toString()),
      profilUrl: result['profile_photo_url'],
    );


    _akun = akunBaru;
    await SessionHelper.saveUserSession(newToken, akunBaru, true);
    print("Nama baru dari server: ${result['nama']}");
    print("AkunBaru.nama: ${akunBaru.nama}");

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
Future<bool> uploadFotoProfil(File foto) async {
  final url = await _service.uploadFoto(foto);
  if (url != null) {
    updateFotoProfil(url);
    return true;
  }
  return false;
}

void updateFotoProfil(String urlBaru) {
  if (_akun != null) {
    _akun = Akun(
      id: _akun!.id,
      username: _akun!.username,
      nama: _akun!.nama,
      email: _akun!.email,
      noHp: _akun!.noHp,
      roleAkunId: _akun!.roleAkunId,
      profilUrl: urlBaru,
      password: _akun!.password,
    );
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