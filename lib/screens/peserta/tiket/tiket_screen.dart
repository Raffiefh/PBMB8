import 'package:flutter/material.dart';
import 'package:pbmuas/models/tiket.dart';
import 'package:pbmuas/services/tiket_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TiketPeserta extends StatefulWidget {
  const TiketPeserta({super.key});

  @override
  State<TiketPeserta> createState() => _RiwayatTiketScreenState();
}

class _RiwayatTiketScreenState extends State<TiketPeserta> {
  late Future<List<RiwayatTiket>> _futureRiwayat;

  @override
  void initState() {
    super.initState();
    _futureRiwayat = TiketService().fetchRiwayatTiket();
  }

  void _showQRDialog(BuildContext context, String qrCode, String eventTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'QR Code Tiket',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  eventTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: QrImageView(
                    data: qrCode,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Riwayat Tiket",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<RiwayatTiket>>(
        future: _futureRiwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Terjadi kesalahan: ${snapshot.error}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tidak ada tiket.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final tiket = data[index];
              final isUsed = tiket.status.toLowerCase() == 'used';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isUsed 
                          ? [Colors.grey[300]!, Colors.grey[400]!]
                          : [Colors.blue[400]!, Colors.blue[600]!],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with status badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  tiket.transaksi.event.judul,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isUsed ? Colors.grey[600] : Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isUsed ? 'TERPAKAI' : 'AKTIF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Event details
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  Icons.calendar_today,
                                  "Tanggal",
                                  tiket.transaksi.event.tanggalEvent,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  Icons.access_time,
                                  "Jam",
                                  tiket.transaksi.event.jamMulai,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  Icons.location_on,
                                  "Lokasi",
                                  tiket.transaksi.event.lokasi,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // QR Code section
                          Center(
                            child: GestureDetector(
                              onTap: isUsed 
                                ? null 
                                : () => _showQRDialog(
                                    context, 
                                    tiket.qrCode, 
                                    tiket.transaksi.event.judul
                                  ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isUsed ? Colors.grey[400]! : Colors.blue[200]!,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.qr_code,
                                      size: 48,
                                      color: isUsed ? Colors.grey[500] : Colors.blue[600],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isUsed ? 'QR Code Tidak Aktif' : 'Tap untuk melihat QR Code',
                                      style: TextStyle(
                                        color: isUsed ? Colors.grey[500] : Colors.blue[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}