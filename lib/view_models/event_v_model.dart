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
    _setLoading(true);
    try {
      _events = await _eventService.getEventsPeserta();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load events: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadEventsMaps() async {
    _setLoading(true);
    try {
      _events = await _eventService.getEventsMaps();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load events: $e';
    } finally {
      _setLoading(false);
    }
  }
  

  Future<void> loadEventsPanitia() async {
    _setLoading(true);
    try {
      _events = await _eventService.getEventsPanitia();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load events: $e';
    } finally {
      _setLoading(false);
    }
  }
Event? _selectedEvent;
bool? _eventHasTransaction;

Event? get selectedEvent => _selectedEvent;
bool? get eventHasTransaction => _eventHasTransaction;

Future<void> fetcchEventDetail(int id) async {
  try {
    final detail = await _eventService.getEventDetail(id);
    _selectedEvent = detail['event'];
    _eventHasTransaction = detail['ada_transaksi'];
    notifyListeners();
  } catch (e) {
    throw Exception('Gagal memuat data event: $e');
  }
}


  Future<bool> addEvent(Map<String, dynamic> data, File foto) async {
    _setLoading(true);
    try {
      final success = await _eventService.createEvent(data, foto);
      if (success) {
        await loadEventsPanitia();
        return true;
      } else {
        _errorMessage = 'Gagal membuat event: Response tidak valid';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Gagal membuat event: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //Sepertinya ada yang salah di database, perlu diperbaiki sih
  Future<bool> updateEvent(int id, Map<String, dynamic> data, File? foto) async {
  _setLoading(true);
  try {
    final success = await _eventService.editEvent(id, data, foto: foto);
    if (success) {
      await loadEventsPanitia();
      return true;
    } else {
      _errorMessage = 'Gagal mengedit event: Response tidak valid';
      return false;
    }
  } catch (e) {
    _errorMessage = 'Gagal mengedit event: ${e.toString()}';
    return false;
  } finally {
    _setLoading(false);
  }
}


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
