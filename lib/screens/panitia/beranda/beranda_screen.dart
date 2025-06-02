import 'package:flutter/material.dart';
import 'package:pbmuas/screens/panitia/beranda/tambah_event_screen.dart';
class Event {
  final String id;
  final String nama;
  final String lokasi;
  final DateTime tanggal;
  final String gambarUrl;

  Event({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.tanggal,
    required this.gambarUrl,
  });
}

class BerandaContent extends StatelessWidget {
  const BerandaContent({super.key});

  // Dummy event list
  List<Event> _dummyEvents() {
    return [
      Event(
        id: '1',
        nama: 'Sound Horeq Festival 2025',
        lokasi: 'Lapangan Jember',
        tanggal: DateTime(2025, 7, 15),
        gambarUrl:
            'https://magicspecialevents.com/event-rentals/wp-content/uploads/Welcome-Sign-Banner-Magic-Special-Events-2-1.jpg',
      ),
      Event(
        id: '2',
        nama: 'Horeq Musik Indie',
        lokasi: 'Alun-alun Kota',
        tanggal: DateTime(2025, 8, 10),
        gambarUrl:
            'https://images.unsplash.com/photo-1497032205916-ac775f0649ae?auto=format&fit=crop&w=800&q=60',
      ),
    ];
  }

 void _onTambahEvent(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const CreateEventScreen(),
    ),
  );
}


  void _onDetail(BuildContext context, Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Detail: ${event.nama}")),
    );
  }

  void _onEdit(BuildContext context, Event event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Edit: ${event.nama}")),
    );
  }

  void _onDelete(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Event"),
        content: Text("Yakin ingin menghapus '${event.nama}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Event '${event.nama}' dihapus")),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = _dummyEvents();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
           const SizedBox(height: 30),
          Row(
            children: [
              const Text(
                "Event Anda",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _onTambahEvent(context),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Event"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text("Belum ada event yang dibuat."))
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Image.network(
                              event.gambarUrl,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.nama,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("📍 ${event.lokasi}"),
                                  Text("📅 ${event.tanggal.toLocal().toString().split(' ')[0]}"),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => _onDetail(context, event),
                                        child: const Text("Detail"),
                                      ),
                                      TextButton(
                                        onPressed: () => _onEdit(context, event),
                                        child: const Text("Edit"),
                                      ),
                                      TextButton(
                                        onPressed: () => _onDelete(context, event),
                                        child: const Text(
                                          "Hapus",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
