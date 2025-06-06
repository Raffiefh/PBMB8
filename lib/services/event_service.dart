import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pbmuas/const/api_url.dart' as url;
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/helpers/session_helper.dart';

class EventService {
  final String apiUrl = '${url.baseUlr}/events';

  Future<Map<String, String>> _getHeaders() async {
    final token = await SessionHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  Future<List<Event>> getEventsPeserta() async {
    final response = await http.get(Uri.parse('$apiUrl/peserta'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> getEventsPanitia() async {
    final response = await http.get(Uri.parse('$apiUrl/panitia'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

 Future<bool> createEvent(Map<String, dynamic> data, File foto) async {
  final headers = await _getHeaders();
  final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/create'));
  
  request.fields.addAll(data.map((key, value) => MapEntry(key, value.toString())));
  request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
  request.headers.addAll(headers);

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  print("Status code: ${response.statusCode}");
  print("Body: $responseBody");

  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonResponse = jsonDecode(responseBody);
    // Pastikan response mengandung 'message' success
    if (jsonResponse['message']?.toLowerCase().contains('berhasil') ?? false) {
      return true;
    }
  }
  
  throw Exception(jsonDecode(responseBody)['detail'] ?? "Gagal membuat event");
}
}
