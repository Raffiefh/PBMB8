import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pbmuas/screens/peserta/akun/akun_screen.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';


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
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Logo di kiri
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/EHO.png', height: 36),
                ),
                // Teks di tengah
                const Center(
                  child: Text(
                    'Beranda Peserta',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
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
                  buildUserCard(context),
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

  Widget buildUserCard(BuildContext context) {
  final authVModel = Provider.of<AuthVModel>(context);
  final String nama = authVModel.akun?.nama ?? 'Peserta';

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AkunPeserta()),
            );
          },
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.person, size: 30, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Halo $nama',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
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
    child: Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          _scrollController.jumpTo(
            _scrollController.offset + pointerSignal.scrollDelta.dy,
          );
        }
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _scrollController.jumpTo(
            _scrollController.offset - details.delta.dx,
          );
        },
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

  Widget _iconTextWithTitle(String title, IconData icon, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 0),
      Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.blue,
                          title: Text(
                            event['title']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    event['image']!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.broken_image, size: 50),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),  // beri jarak antara image dan teks
                                  const Text(
                                    'Saksikan konser favoritmu !!!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(221, 122, 99, 99),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                        _iconTextWithTitle('Tanggal', Icons.calendar_today, event['date'] ?? '-'),
                                        const SizedBox(height: 0),
                                        _iconTextWithTitle('Waktu', Icons.access_time, event['time'] ?? '-'),
                                        const SizedBox(height: 0),
                                        _iconTextWithTitle('Lokasi', Icons.location_on, event['location'] ?? '-'),
                                        const SizedBox(height: 0),
                                        _iconTextWithTitle('Kecamatan', Icons.map, event['kecamatan'] ?? '-'),
                                        const SizedBox(height: 0),
                                        _iconTextWithTitle('Harga', Icons.monetization_on, event['price'] ?? '-'),
                                        const SizedBox(height: 0),
                                        _iconTextWithTitle('Tipe Tiket', Icons.confirmation_number, event['ticket_type'] ?? '-'),
                                        const SizedBox(height: 0),
                                        _iconTextWithTitle('Kuota Tiket', Icons.group, event['ticket_quota'] ?? '-'),
                                      ],

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
  int qty = 1;

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lanjutkan ke Pembayaran?'),
          content: Text('Total yang harus dibayar: Rp ${_totalPrice().toStringAsFixed(0)}\nApakah kamu ingin melanjutkan?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isConfirmed = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  double _totalPrice() {
    final priceString = widget.event['price'] ?? '0';
    final numeric = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(numeric) ?? 0;
    return qty * price;
  }

  Widget _buildQtySelector() {
  return Row(
    children: [
      const Icon(Icons.confirmation_number, color: Colors.black54),
      const SizedBox(width: 8),
      const Text('Jumlah Tiket:'),
      const SizedBox(width: 8),
      IconButton(
        onPressed: qty > 1 ? () => setState(() => qty--) : null,
        icon: const Icon(Icons.remove),
      ),
      SizedBox(
        width: 40, // Atur lebar tetap
        child: Center(
          child: Text(
            '$qty',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      IconButton(
        onPressed: () => setState(() => qty++),
        icon: const Icon(Icons.add),
      ),
    ],
  );
}

  Widget _buildDetailRow(IconData icon, String label, String? value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          Expanded(
            child: Text(value ?? '-',
                style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Pembelian', style: TextStyle(color: Colors.white)),
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
                Text(widget.event['title'] ?? 'Judul tidak tersedia',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                _buildDetailRow(Icons.attach_money, 'Harga per Tiket', widget.event['price']),
                const SizedBox(height: 12),
                _buildQtySelector(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total Harga: Rp ${_totalPrice().toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
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
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
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
