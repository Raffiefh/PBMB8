import 'dart:io';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'location_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:pbmuas/view_models/event_v_model.dart';
import 'package:another_flushbar/flushbar.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  DateTime? _tanggalEvent;
  TimeOfDay? _jamMulai;
  final TextEditingController _durasiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  LatLng? koordinat;
  LatLng defaultInitialLocation = LatLng(-8.1737, 113.7002);
  int? _tipeTiket;
  File? _selectedImage;
  bool _isLoading = false;
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
      initialTime: _jamMulai ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _jamMulai) {
      setState(() {
        _jamMulai = picked;
      });
    }
  }

  void _tampilanPesanSuccess() {
    Flushbar(
      messageText: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Event berhasil ditambahkan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      duration: const Duration(milliseconds: 2500),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10),
      animationDuration: const Duration(milliseconds: 3000),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }

  void _tampilanPesanError() {
    Flushbar(
      messageText: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Event gagal ditambahkan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(10),
      animationDuration: const Duration(milliseconds: 3000),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
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
                },
              ),
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

  void _submitForm() async {
    // Navigator.of(context).pop();
    // _tampilanPesanSuccess();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    if (_tanggalEvent == null || _jamMulai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tanggal dan jam harus dipilih")),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Foto event harus dipilih")));
      return;
    }

    if (koordinat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Lokasi event harus dipilih")),
      );

      return;
    }
    try {
      final jamMulaiString = _jamMulai!.format(context);
      final durasi = int.tryParse(_durasiController.text) ?? 0;
      if (durasi <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Durasi event harus lebih dari 0")),
        );
        return;
      } else if (durasi > 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Durasi event tidak boleh lebih dari 8 jam"),
          ),
        );
        return;
      }
      final tipeTiket = _tipeTiket ?? 0;
      final authModel = Provider.of<AuthVModel>(context, listen: false);
      final akun = authModel.akun!.id;
      final jumlahTiket = int.tryParse(_jumlahController.text) ?? 0;

      // Jika tipe tiket berbayar, validasi harga
      double? hargaTiket;
      if (tipeTiket == 2) {
        hargaTiket = double.tryParse(_hargaController.text);
        if (hargaTiket == null || hargaTiket < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Harga tiket tidak valid")),
          );
          return;
        }
      }

      final eventData = {
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'tanggal_event':
            _tanggalEvent!.toIso8601String().split('T')[0], // Hanya tanggal
        'jam_mulai':
            '${_jamMulai!.hour.toString().padLeft(2, '0')}:${_jamMulai!.minute.toString().padLeft(2, '0')}:00', // "HH:MM:SS"
        'durasi_event': durasi,
        'tipe_tiket': tipeTiket,
        'jumlah_tiket': jumlahTiket,
        'harga_tiket': hargaTiket ?? 0.0,
        'lokasi': _lokasiController.text,
        'latitude': koordinat!.latitude,
        'longitude': koordinat!.longitude,
        'akun_id': akun,
        // 'created_at': DateTime.now().toIso8601String(),
      };
      final eventVM = Provider.of<EventVModel>(context, listen: false);

      final success = await eventVM.addEvent(eventData, _selectedImage!);
      if (success) {
        Navigator.of(context).pop();
        _tampilanPesanSuccess();
      } else {
        _tampilanPesanError();
      }
    } catch (e) {
      if (mounted) {
        _tampilanPesanError();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalEvent ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _tanggalEvent = picked;
      });
    }
  }

  Future<void> _navigateToSelectLocationScreen() async {
    final LatLng initialMapLocation = koordinat ?? defaultInitialLocation;

    final selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                SelectLocationScreen(initialLocation: initialMapLocation),
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Event')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                "Nama Event",
                width,
                controller: _judulController,
                validator: (value) {
                  if (value!.length < 5) {
                    return "Minimal 5 karakter";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                "Deskripsi Event", 
                width,
                controller: _deskripsiController,
                keyboardType: TextInputType.multiline, 
                minLines: 3, 
                maxLines: 5,
                validator: (value) {
                  if (value!.length < 10) { 
                    return "Deskripsi minimal 10 karakter";
                  }
                  return null;
                },
          ),
              // Lokasi manual (Alamat)
              _buildTextField(
                "Lokasi Event", 
                width,
                controller: _lokasiController,
                validator: (value) {
                  if (value!.length < 5) { 
                    return "Minimal 5 karakter";
                  }else if (!RegExp(r"^[a-zA-Z0-9\s]+$").hasMatch(value)) {
                    return "Lokasi tidak boleh mengandung simbol.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Tanggal
              Row(
                children: [
                  const Text("Tanggal Event:"),
                  const SizedBox(width: 12),
                  Expanded(
                    // Agar teks tanggal bisa wrap jika panjang
                    child: Text(
                      _tanggalEvent == null
                          ? "Belum dipilih"
                          : "${_tanggalEvent!..day}/${_tanggalEvent!.month}/${_tanggalEvent!.year}", // Format lebih umum
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
                      _jamMulai == null
                          ? "Belum dipilih"
                          : "${_jamMulai!.format(context)}",
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
              DropdownButtonFormField<int>(
                value: _tipeTiket,
                decoration: const InputDecoration(labelText: "Tipe Tiket"),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Gratis")),
                  DropdownMenuItem(value: 2, child: Text("Berbayar")),
                ],
                onChanged: (value) => setState(() => _tipeTiket = value),
                validator: (val) => val == null ? "Pilih tipe tiket" : null,
              ),
              if (_tipeTiket == 2)
                _buildTextField(
                  "Harga Tiket",
                  width,
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    final parsedValue  = int.tryParse(value!);
                    if (parsedValue == null) {
                      return "Masukkan angka yang valid";
                    }
                    if (parsedValue <= 0) {
                      return "Masukkan angka yang valid (lebih dari 0)";
                    }
                    if (parsedValue > 1000000) {
                      return "Harga tiket tidak boleh lebih dari 1.000.000";
                    }
                    return null;
                  }),
               
              const SizedBox(height: 12),
              _buildTextField(
                "Jumlah Tiket",
                width,
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsedValue  = int.tryParse(value!);
                  if (parsedValue == null) {
                    return "Masukkan angka yang valid";
                  }
                  if (parsedValue <= 0) {
                    return "Masukkan angka yang valid (lebih dari 0)";
                  }
                  if (parsedValue > 500) {
                    return "Jumlah tiket tidak boleh lebih dari 500";
                  } 
                  if (parsedValue < 50) {
                    return "Jumlah tiket tidak boleh kurang dari 50";
                  }
                  return null;
                },
              ),
              // Durasi Event (dalam menit)
              _buildTextField(
                "Durasi Event (jam)",
                width,
                controller: _durasiController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsedValue  = int.tryParse(value!);
                  if (parsedValue == null) {
                    return "Masukkan angka yang valid";
                  }
                  if (parsedValue <= 0) {
                    return "Masukkan angka yang valid (lebih dari 0)";
                  }if (parsedValue > 10) {
                    return "Durasi tidak boleh lebih dari 10 jam";
                  }
                  return null;
                },
              ),
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
                    child:
                        _selectedImage == null
                            ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Tambah Gambar',
                                  style: TextStyle(color: Colors.grey),
                                ),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            koordinat == null
                                ? "Ketuk untuk memilih lokasi di peta"
                                : "Lat: ${koordinat!.latitude.toDouble()}, Lng: ${koordinat!.longitude.toDouble()}",
                            style: TextStyle(
                              color:
                                  koordinat == null
                                      ? Colors.grey[600]
                                      : Colors.black,
                            ),
                          ),
                        ),
                        const Icon(Icons.map, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Simpan
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon:
                    _isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                        : const Icon(Icons.save),
                label:
                    _isLoading
                        ? const Text("Menyimpan...")
                        : const Text("Simpan Event"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor:
                      Theme.of(context).primaryColor, // Contoh styling
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  disabledForegroundColor: Colors.white, // Contoh styling
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 

  Widget _buildTextField(
    String hint, 
    double width, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Color? underlineColor,
    Color? focusedUnderlineColor,
    int? maxLines, 
    int? minLines,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines, 
      minLines: minLines, 
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$hint tidak boleh kosong';
        }
        if (validator != null) {
          return validator(value);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: width * 0.035,
          color: Colors.blue,
        ),
        focusColor: Colors.blue,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: underlineColor ?? const Color(0xFFBCBCBC),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusedUnderlineColor ?? Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}
