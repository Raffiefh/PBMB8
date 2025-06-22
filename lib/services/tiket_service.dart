import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbmuas/helpers/session_helper.dart';
import 'package:pbmuas/models/tiket.dart';
import 'package:pbmuas/const/api_url.dart' as url;

class TiketService {
  final String apiUrl = '${url.baseUlr}/tiket';

  Future<Map<String, String>> _getHeaders() async {
    final token = await SessionHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<RiwayatTiket>> fetchRiwayatTiket() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$apiUrl/riwayat'),
      headers : headers
    );

    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      return result.map((e) => RiwayatTiket.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil riwayat tiket');
    }
  }
 Future<String?> scanTiket(String qrCode) async {
  try {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$apiUrl/scan-tiket'),
      headers: headers,
      body: json.encode({'qr_code': qrCode}),
    );

    if (response.statusCode == 200) {
      return null; // sukses, tidak ada error
    } else if (response.statusCode == 400 || response.statusCode == 403 || response.statusCode == 404) {
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        return errorData['detail'] ?? 'Tiket gagal digunakan';
      } catch (e) {
        return 'Terjadi kesalahan parsing: ${response.body}';
      }
    } else {
      print('Unexpected error: ${response.statusCode} - ${response.body}');
      return 'Terjadi kesalahan server (${response.statusCode})';
    }
  } catch (e) {
    return 'Terjadi kesalahan jaringan: ${e.toString()}';
  }
}



}
