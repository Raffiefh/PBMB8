import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class SelectLocationScreen extends StatefulWidget {
  final LatLng initialLocation;

  const SelectLocationScreen({super.key, required this.initialLocation});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  late LatLng _currentCenter;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialLocation;
    _selectedLocation = widget.initialLocation; 
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Layanan lokasi dinonaktifkan. Mohon aktifkan layanan lokasi.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak.')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.')));
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _currentCenter = _selectedLocation!;
        _mapController.move(_currentCenter, 15.0);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi saat ini berhasil didapatkan!")),
      );
    } catch (e) {
      print("Error mendapatkan lokasi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mendapatkan lokasi saat ini.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi"),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, _selectedLocation); 
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
              onPositionChanged: (position, hasGesture) {
             
                // _currentCenter = position.center!;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(Icons.location_pin,
                          size: 40, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 70,
            right: 16,
            child: FloatingActionButton(
              heroTag: "currentLocationButton", // Tag unik untuk Hero
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          if (_selectedLocation != null)
             Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Terpilih: ${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}",
                         textAlign: TextAlign.center,
                    ),
                  ),
                ),
            )
        ],
      ),
      floatingActionButton: _selectedLocation != null ? FloatingActionButton.extended(
        heroTag: "confirmButton", // Tag unik untuk Hero
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        label: const Text("Konfirmasi Lokasi"),
        icon: const Icon(Icons.check_circle_outline),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}