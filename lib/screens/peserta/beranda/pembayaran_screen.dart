import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/screens/peserta/beranda/beranda_screen.dart';
import 'package:pbmuas/screens/peserta/beranda/snap_screen.dart';
import 'package:pbmuas/screens/peserta/tiket/tiket_screen.dart';
import 'package:pbmuas/screens/widgets/flushbar.dart';
import 'package:pbmuas/screens/widgets/peserta_navbar%20.dart';
import 'package:pbmuas/services/pembayaran_service.dart';

class PaymentScreen extends StatefulWidget {
  final Event event;
  final int quantity;

  const PaymentScreen({super.key, required this.event, required this.quantity});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _prosesPembayaran();
  }

  Future<void> _prosesPembayaran() async {
    try {
      if (widget.event.tipeTiket == 1) {
        final pemabayaran = await PaymentService().createTransactionFree(
          eventId: widget.event.id ?? 0,
          qty: widget.quantity,
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const NavbarPeserta(initialIndex: 2), // ⬅️ langsung ke tab Tiket
            ),
            (route) => false,
          );


        CustomFlushbar.show(context, message: "Pembayaran berhasil", isSuccess: true);
      }
      if (widget.event.tipeTiket == 2) {
        final response = await PaymentService().createTransaction(
          eventId: widget.event.id ?? 0,
          qty: widget.quantity,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => SnapWebViewScreen(
                  paymentResponse: response,
                  event: widget.event,
                  quantity: widget.quantity,
                ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proses Pembayaran')),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage != null
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _prosesPembayaran,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
                : const Text("Transaksi berhasil!"),
      ),
    );
  }
}
