import 'package:flutter/material.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/screens/panitia/beranda/edit_event_screen.dart';
import 'package:pbmuas/screens/panitia/beranda/tambah_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/view_models/event_v_model.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _HomePanitiaPageState();
}

class _HomePanitiaPageState extends State<BerandaPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventVModel>(context, listen: false).loadEventsPanitia();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventList = Provider.of<EventVModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeaderSection(),
            Expanded(child: _buildEventList(eventList)),
          ],
        ),
      ),
    );
  }

  // PreferredSizeWidget _buildAppBar() {
  //   return AppBar(
  //     elevation: 0,
  //     backgroundColor: Colors.blue.shade600,
  //       foregroundColor: Colors.white,
  //     title: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           // child: const Icon(Icons.dashboard_rounded, size: 24),
  //         ),
  //         const SizedBox(width: 12),
  //         const Text(
  //           'Dashboard Panitia',
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //     flexibleSpace: Container(
  //       decoration: const BoxDecoration(
  //         gradient: LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           colors: [
  //             Color(0xFF1E3A8A),
  //             Color(0xFF3B82F6),
  //             Color(0xFF60A5FA),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelola Event Anda',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Buat dan kelola event dengan mudah',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateEventScreen(),
                  ),
                ).then((_) {
                  Provider.of<EventVModel>(context, listen: false).loadEventsPanitia();
                });
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Buat Event Baru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade600,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(EventVModel eventList) {
    if (eventList.events.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Daftar Event',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${eventList.events.length} Event',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: eventList.events.length,
              itemBuilder: (context, index) {
                final event = eventList.events[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutBack,
                  child: _buildEventCard(event, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              size: 64,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Event',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai buat event pertama Anda',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header dengan gradient
            Container(
              height: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                   colors: [Colors.blue.shade600, Colors.blue.shade400],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            
            // Bagian gambar event
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.network(
                    event.fotoUrl ?? '',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade400.withOpacity(0.3),
                            Colors.blue.shade600.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: 48,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getTiketColor(event.tipeTiket ?? 0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _tipeTiketText(event.tipeTiket ?? 0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian info event
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.judul ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.deskripsi ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEventInfo(event),
                ],
              ),
            ),

            // Bagian action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.visibility_rounded,
                    label: 'Detail',
                    color: const Color(0xFF3B82F6),
                    onPressed: () => _navigateToDetail(event),
                  ),
                  _buildActionButton(
                    icon: Icons.edit_rounded,
                    label: 'Edit',
                    color: const Color(0xFF059669),
                    onPressed: () => _navigateToEdit(event),
                  ),
                  _buildActionButton(
                    icon: Icons.delete_rounded,
                    label: 'Hapus',
                    color: const Color(0xFFDC2626),
                    onPressed: () => _showDeleteConfirmationDialog(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo(Event event) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _iconText(Icons.date_range_rounded, event.tanggalEvent ?? ''),
              ),
              Expanded(
                child: _iconText(Icons.access_time_rounded, event.jamMulai ?? ''),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _iconText(Icons.location_on_rounded, event.lokasi ?? ''),
              ),
              Expanded(
                child: _iconText(
                  Icons.confirmation_num_rounded,
                  event.hargaTiket != null && event.hargaTiket! > 0
                      ? 'Rp ${event.hargaTiket!.toStringAsFixed(0)}'
                      : 'Gratis',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
            foregroundColor: color,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getTiketColor(int tipe) {
    switch (tipe) {
      case 1:
        return const Color(0xFF059669);
      case 2:
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF6B7280);
    }
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DetailEventScreen(eventId: event.id!),
    //   ),
    // );
  }

  void _navigateToEdit(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(eventId: event.id!),
      ),
    ).then((_) {
      Provider.of<EventVModel>(context, listen: false).loadEventsPanitia();
    });
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_rounded,
                  color: Color(0xFFDC2626),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Konfirmasi Hapus Event',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // color: Colors.blue.shade600,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Apakah Anda yakin ingin menghapus event ini? Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // TODO: Implement delete functionality
                // final eventVModel = Provider.of<EventVModel>(context, listen: false);
                // await eventVModel.deleteEvent(event.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}