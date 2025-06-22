import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/screens/peserta/akun/akun_screen.dart';
import 'package:pbmuas/screens/peserta/beranda/event_terdekat_screen.dart';
import 'package:pbmuas/screens/peserta/beranda/transaksi_screen.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/view_models/event_v_model.dart';
import 'package:latlong2/latlong.dart';

class BerandaPeserta extends StatefulWidget {
  const BerandaPeserta({super.key});

  @override
  State<BerandaPeserta> createState() => _BerandaPesertaState();
}

class _BerandaPesertaState extends State<BerandaPeserta> {
  @override
  void initState() {
    super.initState();
    Provider.of<EventVModel>(context, listen: false).loadEventsPeserta();
  }

  @override
  Widget build(BuildContext context) {
    final eventList = Provider.of<EventVModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar yang lebih kompak
            SliverAppBar(
              expandedHeight: isTablet ? 80 : 60,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.blue.shade600,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Beranda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                titlePadding: EdgeInsets.only(
                  left: isTablet ? 24 : 16,
                  bottom: 12,
                ),
              ),
            ),

            // Header Card yang lebih kompak
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: 12,
                ),
                child: _cardAtas(context),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: 8,
                ),
                child: _buildQuickActions(context, isTablet),
              ),
            ),

            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Daftar Event',
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Event List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              sliver: _buildEventList(eventList, isTablet),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildQuickActions(BuildContext context, bool isTablet) {
  return Container(
    padding: EdgeInsets.all(isTablet ? 16 : 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: _quickActionButton(
            context,
            Icons.map_outlined,
            'Event Terdekat',
            Colors.green,
            () async {
              final eventVM = context.read<EventVModel>();

              // Tampilkan indikator loading saat ambil data
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              try {
                await eventVM.loadEventsMaps(); // Memuat dari API
                Navigator.pop(context); // Tutup loading

                // Arahkan ke peta
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventTerdekatScreen(
                      // initialLocation: const LatLng(-7.8, 110.3),
                      // events: eventVM.events,
                    ),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal memuat event: $e")),
                );
              }
            },
            isTablet,
          ),
        ),
      ],
    ),
  );
}

  Widget _quickActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
    bool isTablet,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : 12,
          horizontal: isTablet ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: isTablet ? 32 : 28, color: color),
            SizedBox(height: isTablet ? 8 : 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(EventVModel eventList, bool isTablet) {
    if (eventList.events.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: isTablet ? 80 : 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada event tersedia',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final event = eventList.events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildEventCard(event, isTablet),
        );
      }, childCount: eventList.events.length),
    );
  }

  Widget _cardAtas(BuildContext context) {
    final authVModel = Provider.of<AuthVModel>(context);
    final String nama = authVModel.akun?.nama ?? 'Peserta';
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(isTablet ? 30 : 25),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AkunPeserta()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
              ),
              child: CircleAvatar(
                radius: isTablet ? 28 : 23,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: isTablet ? 28 : 22,
                  color: Colors.blue.shade600,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo $nama',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: isTablet ? 4 : 2),
                Text(
                  'Temukan konser seru di sekitar kamu!',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gambar Event
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isTablet ? 20 : 16),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                event.fotoUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: isTablet ? 56 : 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak tersedia',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),

          // Konten Card
          Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.judul ?? 'Judul Event',
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: isTablet ? 10 : 8),
                Text(
                  event.deskripsi ?? 'Deskripsi tidak tersedia',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),

                // Info Event
                Wrap(
                  spacing: isTablet ? 16 : 12,
                  runSpacing: isTablet ? 12 : 8,
                  children: [
                    _iconText(
                      Icons.calendar_today_outlined,
                      event.tanggalEvent ?? '',
                      isTablet,
                    ),
                    _iconText(
                      Icons.access_time_outlined,
                      event.jamMulai ?? '',
                      isTablet,
                    ),
                    _iconText(
                      Icons.location_on_outlined,
                      event.lokasi ?? '',
                      isTablet,
                    ),
                    _iconText(
                      Icons.confirmation_num_outlined,
                      '${_tipeTiketText(event.tipeTiket ?? 0)} - ${event.hargaTiket?.toStringAsFixed(0) ?? "Gratis"}',
                      isTablet,
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 20 : 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Beli Tiket
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToBuyTicket(event),
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 18,
                        ),
                        label: Text(
                          'Beli Tiket',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16 : 12,
                            vertical: isTablet ? 12 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 10 : 8,
                            ),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Tombol Lihat Detail
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToDetail(event),
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue.shade600,
                          side: BorderSide(color: Colors.blue.shade600),
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16 : 12,
                            vertical: isTablet ? 12 : 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 10 : 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isTablet ? 18 : 16, color: Colors.blue.shade600),
        SizedBox(width: isTablet ? 6 : 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 14 : 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
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

  void _navigateToBuyTicket(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransaksiScreen(event: event)),
    );
  }

  void _navigateToDetail(Event event) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: const Color(0xFFF8FBFF),
              appBar: AppBar(
                title: Text(
                  event.judul ?? 'Detail Event',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.blue.shade600,
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Event
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: Image.network(
                            event.fotoUrl ?? '',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported_outlined,
                                        size: isTablet ? 64 : 56,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Gambar tidak tersedia',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: isTablet ? 16 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Judul Event
                    Text(
                      event.judul ?? 'Judul Event',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    SizedBox(height: isTablet ? 16 : 12),

                    // Deskripsi
                    if (event.deskripsi != null && event.deskripsi!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16 : 12,
                          ),
                        ),
                        child: Text(
                          event.deskripsi!,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Detail Information
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Event',
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: isTablet ? 16 : 12),
                            _buildDetailItem(
                              Icons.calendar_today_outlined,
                              'Tanggal',
                              event.tanggalEvent ?? '-',
                              isTablet,
                            ),
                            _buildDetailItem(
                              Icons.access_time_outlined,
                              'Waktu',
                              event.jamMulai ?? '-',
                              isTablet,
                            ),
                            _buildDetailItem(
                              Icons.location_on_outlined,
                              'Lokasi',
                              event.lokasi ?? '-',
                              isTablet,
                            ),
                            _buildDetailItem(
                              Icons.confirmation_num_outlined,
                              'Tiket',
                              '${_tipeTiketText(event.tipeTiket ?? 0)} - ${event.hargaTiket?.toStringAsFixed(0) ?? "Gratis"}',
                              isTablet,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToBuyTicket(event),
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 20,
                        ),
                        label: Text(
                          'Beli Tiket Sekarang',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 16 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 16 : 12,
                            ),
                          ),
                          elevation: 3,
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

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 12 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: isTablet ? 24 : 20,
              color: Colors.blue.shade600,
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
