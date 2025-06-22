import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pbmuas/screens/widgets/flushbar.dart';
import 'package:pbmuas/screens/widgets/peserta_navbar%20.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/models/pembayaran.dart';


class SnapWebViewScreen extends StatefulWidget {
  final PaymentResponse paymentResponse;
  final Event event;
  final int quantity;

  const SnapWebViewScreen({
    super.key,
    required this.paymentResponse,
    required this.event,
    required this.quantity,
  });

  @override
  State<SnapWebViewScreen> createState() => _SnapWebViewScreenState();
}

class _SnapWebViewScreenState extends State<SnapWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Inisialisasi WebView
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.paymentResponse.redirectUrl ?? ''))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
        ),
      );

    // Langsung redirect setelah 10 detik tanpa cek URL
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const NavbarPeserta(initialIndex: 2), // ⬅️ langsung ke tab Tiket
            ),
            (route) => false,
          );
        CustomFlushbar.show(context, message: "Pembayaran berhasil", isSuccess: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final harga = widget.paymentResponse.hargaTotal;

    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(minHeight: 2),

          

          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
