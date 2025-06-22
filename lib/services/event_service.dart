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
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$apiUrl/peserta'),
      headers: headers
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> getEventsMaps() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$apiUrl/lokasi-event'),
      headers: headers
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Event>> getEventsPanitia() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$apiUrl/penyelenggara',
      ),
      headers: headers
      );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(response.body);
      return jsonResponse.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
  Future<Map<String, dynamic>> getEventDetail(int id) async {
  final headers = await _getHeaders();
  final response = await http.get(
    Uri.parse('$apiUrl/penyelenggara/$id'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final eventJson = data['event'];
    final adaTransaksi = data['ada_transaksi'] ?? false;
    final event = Event.fromJson(eventJson);
    return {
      'event': event,
      'ada_transaksi': adaTransaksi,
    };
  } else {
    throw Exception('Gagal memuat data event');
  }
}



  Future<bool> createEvent(Map<String, dynamic> data, File foto) async {
    final headers = await _getHeaders();
    final request = http.MultipartRequest('POST', Uri.parse('$apiUrl/create'));

    request.fields.addAll(
      data.map((key, value) => MapEntry(key, value.toString())),
    );
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    request.headers.addAll(headers);

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print("Status code: ${response.statusCode}");
    print("Body: $responseBody");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(responseBody);
      // Pastikan response mengandung 'message' success
      if (jsonResponse['message']?.toLowerCase().contains('berhasil') ??
          false) {
        return true;
      }
    }

    throw Exception(
      jsonDecode(responseBody)['detail'] ?? "Gagal membuat event",
    );
  }

  Future<bool> editEvent(int eventId, Map<String, dynamic> data, {File? foto}) async {
  final headers = await _getHeaders();
  final request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$eventId'));

  // Tambahkan field yang tidak null
  data.forEach((key, value) {
    if (value != null) {
      request.fields[key] = value.toString();
    }
  });

  // Tambahkan foto jika ada
  if (foto != null) {
    request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
  }

  request.headers.addAll(headers);

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  print("Status code: ${response.statusCode}");
  print("Response body: $responseBody");

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(responseBody);
    return jsonResponse['message']?.toLowerCase().contains('berhasil') ?? false;
  } else {
    throw Exception(jsonDecode(responseBody)['detail'] ?? "Gagal edit event");
  }
}

}
