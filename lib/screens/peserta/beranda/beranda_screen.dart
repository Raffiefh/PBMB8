import 'package:flutter/material.dart';

class BerandaPeserta extends StatefulWidget {
  const BerandaPeserta({super.key});

  @override
  State<BerandaPeserta> createState() => _BerandaPesertaState();
}

class _BerandaPesertaState extends State<BerandaPeserta> {
  final List<String> _kecamatanList = [
    'Semua Kecamatan',
    'Kaliwates',
    'Sumbersari',
    'Patrang',
    'Ajung',
    'Rambipuji',
    'Balung',
    'Tanggul',
    'Puger',
    'Kencong',
    'Gumukmas',
    'Ambulu',
  ];

  String _selectedKecamatan = 'Semua Kecamatan';
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  int _activeIndicatorIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScroll);
  }

  void _checkScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _activeIndicatorIndex = offset < 100 ? 0 : 1;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredEvents {
    return _allEvents.where((event) {
      final matchesSearch = event['title']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesKecamatan = _selectedKecamatan == 'Semua Kecamatan' ||
          event['kecamatan'] == _selectedKecamatan;
      return matchesSearch && matchesKecamatan;
    }).toList();
  }

  final List<Map<String, String>> _allEvents = [
    {
      'title': 'Sound Horeg Festival 2025',
      'description': 'Festival musik tahunan menghadirkan berbagai genre dan artis nasional.',
      'date': '2025-09-14',
      'time': '19:00 WIB',
      'price': 'Rp50.000',
      'ticket_quota': '1000',
      'ticket_type': 'Reguler',
      'location': 'Lapangan Merdeka Jember',
      'kecamatan': 'Kaliwates',
      'image':
          'https://images.tokopedia.net/blog-tokopedia-com/uploads/2017/12/Blog_Acara-Konser-Musik-Tahunan-di-Indonesia-buat-Pecinta-Musik.jpg',
    },
    {
      'title': 'Rockin’ Night With Local Heroes',
      'description': 'Konser rock gratis menampilkan band lokal terbaik Jember.',
      'date': '2025-09-15',
      'time': '20:00 WIB',
      'price': 'Gratis',
      'ticket_quota': '2000',
      'ticket_type': 'Gratis',
      'location': 'Taman Kota Jember',
      'kecamatan': 'Sumbersari',
      'image':
          'https://dewatiket.id/blog/wp-content/uploads/2024/01/Jadwal-Konser-di-Surabaya.jpg',
    },
    {
      'title': 'Ska & Koplo Party',
      'description': 'Pesta musik seru dengan irama ska dan koplo sepanjang malam.',
      'date': '2025-09-18',
      'time': '19:00 WIB',
      'price': 'Rp25.000',
      'ticket_quota': '800',
      'ticket_type': 'Reguler',
      'location': 'Alun-Alun Jember',
      'kecamatan': 'Patrang',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSComZF17O8zurRo8KaZMN5joV0f43QNEWlnR0JV5twGEqofknPtjfHqtaUwDLmnMkwwO0&usqp=CAU',
    },
    {
      'title': 'Dangdutan Malam Minggu',
      'description': 'Malam penuh goyangan bersama penyanyi dangdut lokal.',
      'date': '2025-09-21',
      'time': '20:00 WIB',
      'price': 'Rp30.000',
      'ticket_quota': '500',
      'ticket_type': 'Reguler',
      'location': 'Halaman Kantor Kecamatan',
      'kecamatan': 'Ajung',
      'image':
          'https://dewatiket.id/blog/wp-content/uploads/2024/12/Jadwal-Konser-2025-di-Indonesia.png',
    },
    {
      'title': 'Hip-Hop Street Beats',
      'description': 'Ajang battle hip-hop dan freestyle dari talenta jalanan Jember.',
      'date': '2025-09-25',
      'time': '18:30 WIB',
      'price': 'Rp40.000',
      'ticket_quota': '600',
      'ticket_type': 'VIP',
      'location': 'Gedung Kesenian Jember',
      'kecamatan': 'Balung',
      'image':
          'https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2023/05/25/IMG_20230525_065605_700_x_465_piksel-970076284.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 12),
            color: Colors.blue,
            child: Row(
              children: [
                Image.asset('assets/EHO.png', height: 36),
                const SizedBox(width: 10),
                const Text(
                  'EHO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildUserCard(),
                  const SizedBox(height: 16),
                  buildSearchAndDropdown(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildIndicator(isActive: _activeIndicatorIndex == 0),
                      const SizedBox(width: 6),
                      buildIndicator(isActive: _activeIndicatorIndex == 1),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _filteredEvents.isEmpty
                        ? const Center(child: Text("Tidak ada konser yang ditemukan."))
                        : ListView.builder(
                            itemCount: _filteredEvents.length,
                            itemBuilder: (context, index) =>
                                buildEventCard(_filteredEvents[index]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage:
                NetworkImage('https://source.unsplash.com/featured/100x100?person'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Halo Agung Indra',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Temukan konser seru di sekitar kamu!',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchAndDropdown() {
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: [
            // Kotak pencarian
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 200,
                maxWidth: 250,
                minHeight: 44,
                maxHeight: 44,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Cari konser...',
                    border: InputBorder.none,
                    icon: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Dropdown kecamatan
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 200,
                maxWidth: 250,
                minHeight: 44,
                maxHeight: 44,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedKecamatan,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: _kecamatanList.map((String kecamatan) {
                      return DropdownMenuItem<String>(
                        value: kecamatan,
                        child: Text(kecamatan),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedKecamatan = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey[400],
      ),
    );
  }

  Widget buildEventCard(Map<String, String> event) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                event['image']!,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event['title']!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Harga: ${event['price']!}",
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(event['title']!),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Tanggal: ${event['date']}"),
                            Text("Waktu: ${event['time']}"),
                            Text("Lokasi: ${event['location']}"),
                            Text("Kecamatan: ${event['kecamatan']}"),
                            Text("Harga Tiket: ${event['price']}"),
                            Text("Jenis Tiket: ${event['ticket_type']}"),
                            Text("Kuota Tiket: ${event['ticket_quota']}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Detail'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke halaman konfirmasi pembelian dengan data event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KonfirmasiPembelian(event: event),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart, size: 18),
                  label: const Text('Beli'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 18, 22, 18),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class KonfirmasiPembelian extends StatefulWidget {
  final Map<String, String> event;
  const KonfirmasiPembelian({super.key, required this.event});

  @override
  State<KonfirmasiPembelian> createState() => _KonfirmasiPembelianState();
}

class _KonfirmasiPembelianState extends State<KonfirmasiPembelian> {
  bool isConfirmed = false;

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lanjutkan ke Pembayaran?'),
          content: const Text('Apakah kamu ingin melanjutkan ke halaman pembayaran sekarang?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isConfirmed = false; // Reset tombol agar bisa ditekan lagi
                });
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                // Tambahkan logika pembayaran di sini
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menuju halaman pembayaran...')),
                );
              },
              child: const Text('Oke'),
            ),
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Konfirmasi Pembelian',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    backgroundColor: const Color.fromARGB(255, 244, 242, 242),
    body: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event['title'] ?? 'Judul tidak tersedia',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 29, 20, 20),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.event['image'] ?? '',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today, 'Tanggal', widget.event['date']),
              _buildDetailRow(Icons.access_time, 'Waktu', widget.event['time']),
              _buildDetailRow(Icons.location_on, 'Lokasi', widget.event['location']),
              _buildDetailRow(Icons.map, 'Kecamatan', widget.event['kecamatan']),
              _buildDetailRow(Icons.confirmation_number, 'Jenis Tiket', widget.event['ticket_type']),
              _buildDetailRow(Icons.event_seat, 'Kuota Tiket', widget.event['ticket_quota']),
              _buildDetailRow(Icons.attach_money, 'Harga', widget.event['price'], isBold: true),
              const SizedBox(height: 75), // Jarak lebih jauh sebelum tombol
              SizedBox(
                width: constraints.maxWidth,
                child: ElevatedButton(
                  onPressed: isConfirmed
                      ? null
                      : () {
                          setState(() {
                            isConfirmed = true;
                          });
                          _showConfirmationDialog();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 106, 189),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isConfirmed ? 'Pembelian Berhasil' : 'Konfirmasi Pembelian',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12), // Tambahan jarak bawah agar tidak terlalu mepet bawah layar
            ],
          ),
        );
      },
    ),
  );
}



Widget _buildDetailRow(IconData icon, String label, dynamic value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value?.toString() ?? '-',
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: isBold ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}