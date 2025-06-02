import 'dart:io';

import 'package:flutter/material.dart';
// Hapus flutter_map dan MapController jika tidak digunakan langsung di sini lagi
// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// Geolocator mungkin tidak perlu di sini lagi jika hanya digunakan di SelectLocationScreen
// import 'package:geolocator/geolocator.dart';
import 'location_screen.dart'; // Import layar peta baru
import 'package:image_picker/image_picker.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String namaEvent = '';
  String lokasi = ''; 
  DateTime? tanggal;
  String gambarUrl = '';
  LatLng? koordinat; 
  String deskripsi = '';
  TimeOfDay? jamMulai;
  String? tipeTiket;
  int? durasi;
  int? hargaTiket;
  int? jumlahTiket;
 
  LatLng defaultInitialLocation = LatLng(-8.1737, 113.7002); 
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      
    }
  }
  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
   context: context,
   initialTime: jamMulai ?? TimeOfDay.now(),
  );
  if (picked != null && picked != jamMulai) {
   setState(() {
    jamMulai = picked;
   });
  }
 }
void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeri'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (koordinat == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih lokasi di peta terlebih dahulu.")),
        );
        return;
      }

      _formKey.currentState!.save();

      // Cetak hasilnya
      print('Event: $namaEvent');
      print('Lokasi (Alamat): $lokasi');
      print('Tanggal: $tanggal');
      print('Gambar: "kcak"');
      print('Koordinat: ${koordinat!.latitude}, ${koordinat!.longitude}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event berhasil disimpan")),
      );
      
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggal ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        tanggal = picked;
      });
    }
  }
  
  Future<void> _navigateToSelectLocationScreen() async {
    
    final LatLng initialMapLocation = koordinat ?? defaultInitialLocation;

    final selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationScreen(initialLocation: initialMapLocation),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        koordinat = selectedLocation;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // Nama Event
             TextFormField(
                decoration: const InputDecoration(labelText: "Nama Event"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                onSaved: (value) => namaEvent = value!,
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: "Deskripsi Event"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                onSaved: (value) => deskripsi = value!,
              ),
              // Lokasi manual (Alamat)
              TextFormField(
                decoration: const InputDecoration(labelText: "Alamat Lokasi (Deskripsi)"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                onSaved: (value) => lokasi = value!,
              ),
              const SizedBox(height: 12),

              // Tanggal
              Row(
                children: [
                const Text("Tanggal Event:"),
                const SizedBox(width: 12),
                Expanded( // Agar teks tanggal bisa wrap jika panjang
                  child: Text(
                  tanggal == null
                    ? "Belum dipilih"
                    : "${tanggal!.day}/${tanggal!.month}/${tanggal!.year}", // Format lebih umum
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text("Pilih Tanggal"),
                ),
                ],
              ),
              const SizedBox(height: 12),

              // Jam Mulai
              Row(
                children: [
                const Text("Jam Mulai:"),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                  jamMulai == null ? "Belum dipilih" : "${jamMulai!.format(context)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: const Text("Pilih Jam"),
                ),
                ],
              ),
              const SizedBox(height: 12),

              // Tipe Tiket
              Row(
                children: [
                const Text("Tipe Tiket:"),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: tipeTiket,
                  items: <String>['Gratis', 'Berbayar'].map((String value) {
                    return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                    tipeTiket = newValue!;
                    // Reset field harga dan jumlah tiket jika tipe gratis dipilih
                    if (tipeTiket == 'Gratis') {
                      hargaTiket = 0;
                      jumlahTiket = 0;
                    }
                    });
                  },
                  validator: (value) => value == null ? "Wajib dipilih" : null,
                  onSaved: (value) => tipeTiket = value!,
                  ),
                ),
                ],
              ),
              const SizedBox(height: 12),

              // Durasi Event (dalam menit)
              TextFormField(
                decoration: const InputDecoration(labelText: "Durasi Event (menit)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Wajib diisi";
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return "Masukkan angka yang valid";
                }
                return null;
                },
                onSaved: (value) => durasi = int.parse(value!),
              ),
              const SizedBox(height: 12),

              // Harga Tiket (hanya tampil jika tipe tiket berbayar)
              if (tipeTiket == 'Berbayar')
                TextFormField(
                decoration: const InputDecoration(labelText: "Harga Tiket"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (tipeTiket == 'Berbayar') {
                  if (value == null || value.isEmpty) {
                    return "Wajib diisi";
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return "Masukkan angka yang valid";
                  }
                  }
                  return null;
                },
                onSaved: (value) => hargaTiket = int.tryParse(value!) ?? 0,
                ),
              if (tipeTiket == 'Berbayar')
                const SizedBox(height: 12),

              // Jumlah Tiket (hanya tampil jika tipe tiket berbayar)
              if (tipeTiket == 'Berbayar')
                TextFormField(
                decoration: const InputDecoration(labelText: "Jumlah Tiket"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (tipeTiket == 'Berbayar') {
                  if (value == null || value.isEmpty) {
                    return "Wajib diisi";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "Masukkan angka yang valid";
                  }
                  }
                  return null;
                },
                onSaved: (value) => jumlahTiket = int.tryParse(value!) ?? 0,
                ),
              if (tipeTiket == 'Berbayar')
                const SizedBox(height: 12),
                  const SizedBox(height: 12),

                  // URL Gambar
                  GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: _selectedImage == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                                Text('Tambah Gambar', style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                  const SizedBox(height: 16),

              // Tombol untuk Memilih Lokasi GPS
              const Text("Lokasi GPS Event:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  onTap: _navigateToSelectLocationScreen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            koordinat == null
                                ? "Ketuk untuk memilih lokasi di peta"
                                : "Lat: ${koordinat!.latitude.toStringAsFixed(5)}, Lng: ${koordinat!.longitude.toStringAsFixed(5)}",
                            style: TextStyle(
                              color: koordinat == null ? Colors.grey[600] : Colors.black,
                            ),
                          ),
                        ),
                        const Icon(Icons.map, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ),
              if (koordinat == null) 
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Lokasi GPS wajib dipilih",
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),


              // Simpan
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text("Simpan Event"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: Theme.of(context).primaryColor, // Contoh styling
                  foregroundColor: Colors.white, // Contoh styling
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}