import 'package:flutter/material.dart';
import 'package:pbmuas/models/forum.dart';
import 'package:pbmuas/services/forum_service.dart';

class ForumVModel extends ChangeNotifier {
  final ForumService _service = ForumService();
  List<ForumModel> messages = [];
  bool _isLoading = true;

  List<ForumModel> get _messages => messages;
  bool get isLoading => _isLoading;
  void startListening() {
    _service.ambilPesan().listen((data) {
      messages = data.map((e) => ForumModel.fromJson(e)).toList();
      _isLoading = false;
      notifyListeners();
    });
  }
  Future<void> sendMessage(int akunId, String pesan, String username) async {
    await _service.kirimPesan(akunId, pesan, username);
  }

  // bool _isLoading = false;

  // List<ForumMessage> get messages => _messages;
  // bool get isLoading => _isLoading;

  // Future<void> loadMessages() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     _messages = await _service.fetchMessages();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> sendMessage(String username, String pesan) async {
  //   final now = DateTime.now();
  //   final message = ForumMessage(
  //     username: username,
  //     pesan: pesan,
  //     createdAt: now,
  //     tanggal: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
  //     waktu: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
  //   );

  //   await _service.sendMessage(message);
  //   _messages.add(message);
  //   notifyListeners();
  // }
}
