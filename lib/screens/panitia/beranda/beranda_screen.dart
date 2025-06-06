import 'package:flutter/material.dart';
import 'package:pbmuas/screens/panitia/beranda/tambah_event_screen.dart';

class HomePanitiaPage extends StatefulWidget {
  const HomePanitiaPage({super.key});

  @override
  State<HomePanitiaPage> createState() => _HomePanitiaPageState();
}

class _HomePanitiaPageState extends State<HomePanitiaPage> {

  // Dummy data event (nanti bisa diganti dengan data dari API)
  final List<Map<String, String>> events = [
    {
      'id': '1',
      'title': 'Konser Sound Horeg',
      'description': 'Konser musik akbar di Jember!',
      'date': '12 Juni 2025',
      'time': '18:00',
      'location': 'GOR Jember',
      'ticket_type': 'Gratis',
      'price': '0',
      'image': 'https://images.unsplash.com/photo-1503428593586-e225b39bddfe'
    },
    {
      'id': '2',
      'title': 'Seminar Kewirausahaan',
      'description': 'Belajar bisnis dari para praktisi',
      'date': '15 Juli 2025',
      'time': '09:00',
      'location': 'Aula Universitas',
      'ticket_type': 'Berbayar',
      'price': '50.000',
      'image': 'https://images.unsplash.com/photo-1431540015161-0bf868a2d407'
    },
  ];


  @override
  Widget build(BuildContext context) {
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
                      // Refresh data ketika kembali dari tambah event
                      setState(() {});
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
            Expanded(
              child: _buildEventList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index]);
      },
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
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
              event['image']!,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
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
                  event['title']!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  event['description']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _iconText(Icons.date_range, event['date']!),
                    _iconText(Icons.access_time, event['time']!),
                    _iconText(Icons.location_on, event['location']!),
                    _iconText(Icons.confirmation_num,
                        '${event['ticket_type']} - ${event['price']}'),
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
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(event['id']!);
                  },
                ),
              ],
            ),
          )
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
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  void _navigateToDetail(Map<String, String> event) {
    // Navigasi ke halaman detail event
    // Buat file baru untuk DetailEventScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(event['title']!)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  event['image']!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  event['title']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event['description']!,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildDetailItem(Icons.date_range, 'Tanggal', event['date']!),
                _buildDetailItem(Icons.access_time, 'Waktu', event['time']!),
                _buildDetailItem(Icons.location_on, 'Lokasi', event['location']!),
                _buildDetailItem(Icons.confirmation_num, 'Tiket', 
                  '${event['ticket_type']} - ${event['price']}'),
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
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
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

  void _navigateToEdit(Map<String, String> event) {
    // Navigasi ke halaman edit event
    // Asumsi TambahEventScreen bisa menerima parameter untuk mode edit
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventScreen()
      ),
    ).then((_) {
      // Refresh data ketika kembali dari edit event
      setState(() {});
    });
  }

  void _showDeleteConfirmation(String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Event'),
          content: const Text('Apakah Anda yakin ingin menghapus event ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteEvent(eventId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(String eventId) {
    // Hapus event dari list
    setState(() {
      events.removeWhere((event) => event['id'] == eventId);
    });
    
    // Tampilkan snackbar konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event berhasil dihapus'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}