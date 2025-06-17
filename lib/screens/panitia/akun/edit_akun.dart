import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:pbmuas/models/akun.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
class EditAkun extends StatefulWidget {
  final String namaAwal;
  final String emailAwal;
  final String noHpAwal;

  const EditAkun({
    super.key,
    required this.namaAwal,
    required this.emailAwal,
    required this.noHpAwal,
  });

  @override
  State<EditAkun> createState() => _EditAkunState();
}

class _EditAkunState extends State<EditAkun> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  void _tampilanPesanSuccess() {
    Flushbar(
      messageText: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Edit profil berhasil",
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
 void _editProfil() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  final authProvider = Provider.of<AuthVModel>(context, listen: false);

  final akunLama = authProvider.akun;
  if (akunLama == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Akun tidak ditemukan")),
    );
    setState(() => _isLoading = false);
    return;
  }

  final updatedAkun = Akun(
    id: akunLama.id,
    username: akunLama.username,
    roleAkunId: akunLama.roleAkunId,
    password: akunLama.password,
    profilUrl: akunLama.profilUrl,
    nama: _namaController.text,
    email: _emailController.text,
    noHp: _noHpController.text,
  );
  print('Updated Akun: ${updatedAkun.toJson()}');
  final success = await authProvider.updateDataAkun(updatedAkun);

  setState(() {
    _isLoading = false;
  });

  if (success) {
    Navigator.pop(context); 
    _tampilanPesanSuccess();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal memperbarui profil")),
    );
  }
}

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaAwal);
    _emailController = TextEditingController(text: widget.emailAwal);
    _noHpController = TextEditingController(text: widget.noHpAwal);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  void _simpanProfil() {
    Navigator.pop(context, {
      'nama': _namaController.text,
      'email': _emailController.text,
      'noHp': _noHpController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return "Nama hanya boleh mengandung huruf dan spasi.";
                            }
                    if (value.length < 5) {
                      return "Nama lengkap minimal 5 karakter";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "Email tidak valid";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noHpController,
                  decoration: const InputDecoration(
                    labelText: 'No. Telepon',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'No. Telepon tidak boleh kosong';
                    }
                    if (value.length < 9) {
                      return "No. Telepon minimal 9 karakter";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: height * 0.065,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _editProfil,
                    icon:
                        _isLoading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                      Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                              ),
                            )
                            : null,
                    label:
                        _isLoading
                            ? const Text("")
                            : const Text(
                              'EDIT PROFIL',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 380 * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: const Color(0xFF0066CC),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                      disabledForegroundColor:
                          Colors.white, // Contoh styling
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
}
