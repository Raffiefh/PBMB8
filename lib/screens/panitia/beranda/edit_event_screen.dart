import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:pbmuas/models/event.dart';
import 'package:pbmuas/screens/panitia/beranda/location_screen.dart';
import 'package:pbmuas/screens/widgets/flushbar.dart';
import 'package:pbmuas/view_models/event_v_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// import 'package:pbmuas/screens/widgets/location_screen.dart';

class EditEventScreen extends StatefulWidget {
  final int eventId;

  const EditEventScreen({super.key, required this.eventId});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _durasiController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  LatLng defaultInitialLocation = LatLng(-8.1737, 113.7002);
  DateTime? _tanggalEvent;
  TimeOfDay? _jamMulai;
  LatLng? koordinat;
  int? _tipeTiket;
  bool _isLoading = false;
  bool _adaTransaksi = false;
  String? _imageUrl;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String formatTanggal(DateTime? date) {
    if (date == null) return "Belum dipilih";
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatJam24(TimeOfDay? time) {
    if (time == null) return "Belum dipilih";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt); // contoh: 19:22
  }

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    try {
      final eventVM = Provider.of<EventVModel>(context, listen: false);
      await eventVM.fetcchEventDetail(widget.eventId);
      final event = eventVM.selectedEvent;
      final hasTx = eventVM.eventHasTransaction ?? false;

      if (event != null) {
        _judulController.text = event.judul ?? '';
        _deskripsiController.text = event.deskripsi ?? '';
        _lokasiController.text = event.lokasi ?? '';
        _tipeTiket = event.tipeTiket;
        _hargaController.text = event.hargaTiket?.toString() ?? '';
        _jumlahController.text = event.jumlahTiket?.toString() ?? '';
        _durasiController.text = event.durasiEvent?.toString() ?? '';
        _tanggalEvent = DateTime.tryParse(event.tanggalEvent ?? '');
        _jamMulai = TimeOfDay(
          hour: int.tryParse(event.jamMulai?.split(":")[0] ?? '0') ?? 0,
          minute: int.tryParse(event.jamMulai?.split(":")[1] ?? '0') ?? 0,
        );
        koordinat = LatLng(event.latitude ?? 0.0, event.longitude ?? 0.0);
        _adaTransaksi = hasTx;
        _imageUrl = event.fotoUrl;
        setState(() {});
      }
    } catch (e) {
      CustomFlushbar.show(
        context,
        message: "Gagal memuat data event: $e",
        isSuccess: false,
      );
    }
  }

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

  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: _jamMulai ?? TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (picked != null && picked != _jamMulai) {
    setState(() {
      _jamMulai = picked;
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

  void _submitEdit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final jamMulaiString = _jamMulai != null
          ? '${_jamMulai!.hour.toString().padLeft(2, '0')}:${_jamMulai!.minute.toString().padLeft(2, '0')}:00'
          : null;

      final updatedData = {
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'lokasi': _lokasiController.text,
        'tipe_tiket': _tipeTiket,
        'jumlah_tiket': int.tryParse(_jumlahController.text),
        'durasi_event': int.tryParse(_durasiController.text),
        'latitude': koordinat?.latitude,
        'longitude': koordinat?.longitude,
      };

      if (!_adaTransaksi) {
        updatedData['harga_tiket'] = double.tryParse(_hargaController.text);
        updatedData['tanggal_event'] = _tanggalEvent?.toIso8601String().split('T')[0];
        updatedData['jam_mulai'] = jamMulaiString;
      }

      final eventVM = Provider.of<EventVModel>(context, listen: false);
      final success = await eventVM.updateEvent(widget.eventId, updatedData, _selectedImage);

      if (success) {
        Navigator.pop(context);
        CustomFlushbar.show(context, message: "Event berhasil diperbarui", isSuccess: true);
      } else {
        CustomFlushbar.show(context, message: "Gagal memperbarui event", isSuccess: false);
      }
    } catch (e) {
      CustomFlushbar.show(context, message: "Error: $e", isSuccess: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event')),
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
                  } else if (!RegExp(r"^[a-zA-Z0-9\s]+$").hasMatch(value)) {
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
                     formatTanggal(_tanggalEvent),
                       style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _adaTransaksi ? null : _selectDate,
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
                        formatJam24(_jamMulai),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _adaTransaksi
                      ? null
                      : () {
                          _selectTime(context);
                        },
                      child: const Text("Pilih Jam"),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tipe Tiket
              DropdownButtonFormField<int>(
                enableFeedback: !_adaTransaksi,
                value: _tipeTiket,
                decoration: const InputDecoration(labelText: "Tipe Tiket"),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Gratis")),
                  DropdownMenuItem(value: 2, child: Text("Berbayar")),
                ],
                onChanged: !_adaTransaksi
                ? (value) => setState(() => _tipeTiket = value!)
                : null,
                validator: (val) => val == null ? "Pilih tipe tiket" : null,
              ),
              if (_tipeTiket == 2)
                _buildTextField(
                  "Harga Tiket",
                  width,
                  enabled: !_adaTransaksi,
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if(_adaTransaksi) return null;
                    final parsedValue = int.tryParse(value!);
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
                  },
                ),

              const SizedBox(height: 12),
              _buildTextField(
                "Jumlah Tiket",
                width,
                enabled: !_adaTransaksi,
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(_adaTransaksi) return null;
                  final parsedValue = int.tryParse(value!);
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
                  final parsedValue = int.tryParse(value!);
                  if (parsedValue == null) {
                    return "Masukkan angka yang valid";
                  }
                  if (parsedValue <= 0) {
                    return "Masukkan angka yang valid (lebih dari 0)";
                  }
                  if (parsedValue > 10) {
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
                        _selectedImage != null
                            ? Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : (_imageUrl != null && _imageUrl!.isNotEmpty
                                ? Image.network(
                                  _imageUrl!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                : const Column(
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
                                )),
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
                onPressed: _isLoading ? null : _submitEdit,
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
    bool enabled = true,
  }) {
    return TextFormField(
      enabled: enabled,
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
