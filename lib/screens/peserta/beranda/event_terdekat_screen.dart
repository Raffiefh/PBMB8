import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/view_models/event_v_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EventTerdekatScreen extends StatefulWidget {
  const EventTerdekatScreen({super.key});

  @override
  State<EventTerdekatScreen> createState() => _EventTerdekatScreenState();
}

class _EventTerdekatScreenState extends State<EventTerdekatScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  Polyline? _route;
  bool _isLoading = true;
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    setState(() => _isLoading = true);
    
    await _getCurrentLocation();
    if (mounted) {
      await context.read<EventVModel>().loadEventsMaps();
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _getCurrentLocation() async {
    final hasService = await Geolocator.isLocationServiceEnabled();
    if (!hasService) {
      _showSnackBar('Layanan lokasi tidak aktif. Silakan aktifkan GPS Anda.', 
          Icons.location_off, Colors.orange);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showSnackBar('Izin lokasi diperlukan untuk menampilkan posisi Anda', 
          Icons.location_disabled, Colors.red);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentLocation!, 14);
        _showSnackBar('Lokasi Anda berhasil ditemukan!', 
            Icons.location_on, Colors.green);
      }
    } catch (e) {
      _showSnackBar('Gagal mendapatkan lokasi. Coba lagi nanti.', 
          Icons.error, Colors.red);
    }
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _drawRouteToEvent(LatLng eventLocation) async {
    if (_currentLocation == null) {
      _showSnackBar('Lokasi Anda belum ditemukan', Icons.location_off, Colors.orange);
      return;
    }

    setState(() => _isLoadingRoute = true);

    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${_currentLocation!.longitude},${_currentLocation!.latitude};${eventLocation.longitude},${eventLocation.latitude}?geometries=geojson');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;

        final List<LatLng> routePoints = coords.map<LatLng>((point) {
          return LatLng(point[1], point[0]);
        }).toList();

        if (mounted) {
          setState(() {
            _route = Polyline(
              points: routePoints,
              strokeWidth: 5.0,
              color: Colors.blue.shade600,
              pattern: const StrokePattern.solid(),
            );
          });
          _showSnackBar('Rute berhasil ditampilkan!', Icons.route, Colors.blue);
        }
      } else {
        _showSnackBar('Gagal membuat rute. Coba lagi nanti.', 
            Icons.error, Colors.red);
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan saat membuat rute', 
          Icons.error, Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoadingRoute = false);
      }
    }
  }

  void _clearRoute() {
    setState(() => _route = null);
    _showSnackBar('Rute dihapus', Icons.clear, Colors.grey);
  }

  void _recenterToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 14);
      _showSnackBar('Peta dipusatkan ke lokasi Anda', 
          Icons.my_location, Colors.blue);
    } else {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventVM = context.watch<EventVModel>();
    final events = eventVM.events;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'Peta Event Terdekat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_route != null)
            IconButton(
              onPressed: _clearRoute,
              icon: const Icon(Icons.clear),
              tooltip: 'Hapus Rute',
            ),
          IconButton(
            onPressed: _recenterToCurrentLocation,
            icon: const Icon(Icons.my_location),
            tooltip: 'Ke Lokasi Saya',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingWidget()
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentLocation ?? const LatLng(-8.1737, 113.7002),
                        initialZoom: 13,
                        minZoom: 5,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        if (_currentLocation != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentLocation!,
                                width: 50,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              )
                            ],
                          ),
                        MarkerLayer(
                          markers: events
                              .where((e) => e.latitude != null && e.longitude != null)
                              .map(
                                (e) => Marker(
                                  point: LatLng(e.latitude!, e.longitude!),
                                  width: 50,
                                  height: 50,
                                  child: GestureDetector(
                                    onTap: () {
                                      _drawRouteToEvent(LatLng(e.latitude!, e.longitude!));
                                      _showEventInfo(context, e);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade600,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.event,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        if (_route != null)
                          PolylineLayer(
                            polylines: [_route!],
                          ),
                      ],
                    ),
                  ),
                ),
                if (_isLoadingRoute)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Membuat rute...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ketuk marker event untuk melihat detail dan rute',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
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

  Widget _buildLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade50,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Memuat Peta Event...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mohon tunggu sebentar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventInfo(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.event,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.lokasi ?? 'Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Event Details
              if (event.lokasi != null) 
                _buildInfoRow(Icons.location_on, 'Lokasi', event.lokasi!),
              
              if (event.tanggalEvent != null)
                _buildInfoRow(Icons.calendar_today, 'Tanggal', event.tanggalEvent!),
              
              if (event.jamMulai != null)
                _buildInfoRow(Icons.access_time, 'Waktu', event.jamMulai!),
              
              _buildInfoRow(
                Icons.confirmation_number,
                'Tiket',
                event.tipeTiket == 1 
                    ? 'Gratis' 
                    : 'Rp ${event.hargaTiket?.toStringAsFixed(0) ?? '0'}',
                color: event.tipeTiket == 1 ? Colors.green : Colors.orange,
              ),
              
              const SizedBox(height: 24),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _drawRouteToEvent(LatLng(event.latitude!, event.longitude!));
                  },
                  icon: const Icon(Icons.directions, color: Colors.white),
                  label: const Text(
                    'Tampilkan Rute',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: (color ?? Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color ?? Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
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