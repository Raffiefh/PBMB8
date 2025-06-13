import 'package:flutter/material.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/screens/panitia/beranda/tambah_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/view_models/event_v_model.dart';

class HomePanitiaPage extends StatefulWidget {
  const HomePanitiaPage({super.key});

  @override
  State<HomePanitiaPage> createState() => _HomePanitiaPageState();
}

class _HomePanitiaPageState extends State<HomePanitiaPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<EventVModel>(context, listen: false).loadEventsPanitia();
  }
  @override
  Widget build(BuildContext context) {
    final eventList = Provider.of<EventVModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFDAEAF1),

      appBar: AppBar(
        title: const Text('Beranda Panitia'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Daftar Event', style: TextStyle(fontSize: 20)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman tambah event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateEventScreen(),
                      ),
                    ).then((_) {
                      Provider.of<EventVModel>(context, listen: false).loadEventsPanitia(); 
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Buat Event'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildEventList(eventList)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(EventVModel eventList) {
    return ListView.builder(
      itemCount: eventList.events.length,
      itemBuilder: (context, index) {
        final event = eventList.events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(Event event) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bagian gambar event
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              event.fotoUrl ?? '',
              height: 180,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
            ),
          ),

          // Bagian info event
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.judul ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  event.deskripsi ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _iconText(Icons.date_range, event.tanggalEvent ?? ''),
                    _iconText(Icons.access_time, event.jamMulai ?? ''),
                    _iconText(Icons.location_on, event.lokasi ?? ''),
                    _iconText(
                      Icons.confirmation_num,
                      '${_tipeTiketText(event.tipeTiket ?? 0)} - ${event.hargaTiket?.toStringAsFixed(0) ?? "Gratis"}',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bagian action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button Detail
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () {
                    _navigateToDetail(event);
                  },
                ),

                // Button Edit
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    _navigateToEdit(event);
                  },
                ),

                // Button Delete
                // IconButton(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   onPressed: () {
                //     _showDeleteConfirmation(event.id);
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
    String _tipeTiketText(int tipe) {
    switch (tipe) {
      case 1:
        return 'Gratis';
      case 2:
        return 'Berbayar';
      default:
        return 'Tidak Diketahui';
    }
  }
  void _navigateToDetail(Event event) {
    // Navigasi ke halaman detail event
    // Buat file baru untuk DetailEventScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: Text(event.judul ?? '')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      event.fotoUrl ?? '',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      event.judul ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.deskripsi ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      Icons.date_range,
                      'Tanggal',
                      event.tanggalEvent ?? '',
                    ),
                    _buildDetailItem(
                      Icons.access_time,
                      'Waktu',
                      event.jamMulai ?? '',
                    ),
                    _buildDetailItem(
                      Icons.location_on,
                      'Lokasi',
                      event.lokasi ?? '',
                    ),
                    _buildDetailItem(
                      Icons.confirmation_num,
                      'Tiket',
                       '${_tipeTiketText(event.tipeTiket ?? 0)} - ${event.hargaTiket?.toStringAsFixed(0) ?? "Gratis"}',
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(Event event) {
    // Navigasi ke halaman edit event
    // Asumsi TambahEventScreen bisa menerima parameter untuk mode edit
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventScreen()),
    ).then((_) {
      // Refresh data ketika kembali dari edit event
      setState(() {});
    });
  }

  // void _showDeleteConfirmation(int eventId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Hapus Event'),
  //         content: const Text('Apakah Anda yakin ingin menghapus event ini?'),
  //         actions: [
  //           TextButton(
  //             child: const Text('Batal'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Hapus', style: TextStyle(color: Colors.red)),
  //             onPressed: () {
  //               _deleteEvent(eventId);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _deleteEvent(String eventId) {
  //   // Hapus event dari list
  //   setState(() {
  //     events.removeWhere((event) => event['id'] == eventId);
  //   });

  //   // Tampilkan snackbar konfirmasi
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Event berhasil dihapus'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }
}
