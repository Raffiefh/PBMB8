import 'package:flutter/material.dart';

class HomePanitiaPage extends StatefulWidget {
  const HomePanitiaPage({super.key});

  @override
  State<HomePanitiaPage> createState() => _HomePanitiaPageState();
}

class _HomePanitiaPageState extends State<HomePanitiaPage> {
  bool showForm = false;

  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();
  final _hargaController = TextEditingController();
  final _tipeTiketController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _kuotaController = TextEditingController();
  final _gambarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAEAF1), // Telur asin muda
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showForm = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Lihat Event'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showForm = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Buat Event'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: showForm ? _buildEventForm() : _buildEventListDummy(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildInputField('Judul Event', _judulController),
            _buildInputField('Deskripsi', _deskripsiController),
            _buildInputField('Tanggal', _tanggalController),
            _buildInputField('Jam', _jamController),
            _buildInputField('Harga', _hargaController),
            _buildInputField('Jenis Tiket', _tipeTiketController),
            _buildInputField('Lokasi', _lokasiController),
            _buildInputField('Jumlah Tiket', _kuotaController),
            _buildInputField('URL Gambar', _gambarController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event anda berhasil dibuat'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  setState(() {
                    showForm = false;
                    _judulController.clear();
                    _deskripsiController.clear();
                    _tanggalController.clear();
                    _jamController.clear();
                    _hargaController.clear();
                    _tipeTiketController.clear();
                    _lokasiController.clear();
                    _kuotaController.clear();
                    _gambarController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Buat'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEventListDummy() {
    final events = [
      {
        'title': 'Konser Sound Horeg',
        'description': 'Konser musik akbar di Jember!',
        'date': '12 Juni 2025',
        'time': '18:00',
        'location': 'GOR Jember',
        'ticket_type': 'Gratis',
        'price': '0',
        'image':
            'https://images.unsplash.com/photo-1503428593586-e225b39bddfe'
      },
    ];
    return ListView(
      children: events.map(_buildEventCard).toList(),
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
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
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
}
