import 'package:flutter/material.dart';
import '../services/pembayaran_service.dart';
import '../models/pembayaran.dart';

class PaymentViewModel extends ChangeNotifier {
  PaymentResponse? _paymentResponse;
  bool _isLoading = false;
  String? _error;

  PaymentResponse? get paymentResponse => _paymentResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> createTransaction({
    required int eventId,
    required int qty,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _paymentResponse = await PaymentService().createTransaction(
        eventId: eventId,
        qty: qty,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> createTransactionFree({
    required int eventId,
    required int qty,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _paymentResponse = await PaymentService().createTransactionFree(
        eventId: eventId,
        qty: qty,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
