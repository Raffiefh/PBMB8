import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventVModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadEventsPeserta() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _eventService.getEventsPeserta();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _errorMessage = 'Failed to load events: $e';
    }
  }

  Future<void> loadEventsPanitia() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _eventService.getEventsPanitia();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _errorMessage = 'Failed to load events: $e';
    }
  }

 Future<bool> addEvent(Map<String, dynamic> data, File foto) async {
  try {
    final success = await _eventService.createEvent(data, foto);
    print('Service Response: $success'); // Pastikan nilai true diterima
    if (success) {
      await loadEventsPanitia();
      return true;
    }
    _errorMessage = 'Gagal membuat event: Response tidak valid';
    notifyListeners();
    return false;
  } catch (e) {
    _errorMessage = 'Gagal membuat event: ${e.toString()}';
    notifyListeners();
    return false;
  }
}
}
