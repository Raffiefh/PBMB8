import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbmuas/helpers/session_helper.dart';
import 'package:pbmuas/const/api_url.dart' as url;
import '../models/pembayaran.dart';

class PaymentService {
  final String apiUrl = '${url.baseUlr}/tiket/transaksi';

  Future<Map<String, String>> _getHeaders() async {
    final token = await SessionHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<PaymentResponse> createTransaction({
    required int eventId,
    required int qty,
  }) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$apiUrl/$eventId/bayar');

    final body = jsonEncode({'qty': qty});
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      return PaymentResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Gagal membuat transaksi');
    }
  }
   Future<PaymentResponse> createTransactionFree({
    required int eventId,
    required int qty,
  }) async {
    final headers = await _getHeaders();
    final uri = Uri.parse('$apiUrl/$eventId/gratis');

    final body = jsonEncode({'qty': qty});
    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      return PaymentResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Gagal membuat transaksi');
    }
  }
}
