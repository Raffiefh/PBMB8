import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pbmuas/services/tiket_service.dart';
import 'package:pbmuas/screens/widgets/flushbar.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrPage> {
  MobileScannerController controller = MobileScannerController();
  final TiketService _tiketService = TiketService();
  String resultMessage = '';
  bool isProcessing = false;
  bool isSuccess = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  Future<void> _handleBarcodeScan(String? qrCode) async {
    if (qrCode == null || isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    await controller.stop();

    final errorMessage = await _tiketService.scanTiket(qrCode);
    if (errorMessage == null) {
      CustomFlushbar.show(
        context,
        message: "Tiket valid dan berhasil di scan",
        isSuccess: true,
      );
    } else {
      CustomFlushbar.show(
        context,
        message: errorMessage,
        isSuccess: false,
      );
    }

    await Future.delayed(const Duration(seconds: 3));
    setState(() => isProcessing = false);
    await controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          "Scan Tiket",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: Colors.blue.shade600,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
                ),
                child: const Text(
                  "Arahkan kamera ke QR Code tiket",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Scanner area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        MobileScanner(
                          controller: controller,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            if (barcodes.isNotEmpty) {
                              _handleBarcodeScan(barcodes.first.rawValue);
                            }
                          },
                        ),
                        // Overlay scanning frame
                        Center(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.shade300,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                // Corner decorations
                                Positioned(
                                  top: -1,
                                  left: -1,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                        left: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -1,
                                  right: -1,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                        right: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -1,
                                  left: -1,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                        left: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -1,
                                  right: -1,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                        right: BorderSide(
                                          color: Colors.blue.shade600,
                                          width: 4,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),

          // Success/Error message overlay
          if (resultMessage.isNotEmpty)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 20,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isSuccess ? Colors.green.shade600 : Colors.red.shade600,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: (isSuccess ? Colors.green : Colors.red)
                          .withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        resultMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading overlay
          if (isProcessing && resultMessage == "Memproses tiket...")
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade600,
                          ),
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Memproses tiket...",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
