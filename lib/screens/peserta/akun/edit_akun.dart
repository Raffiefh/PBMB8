import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditProfil extends StatefulWidget {
  final String namaAwal;
  final String emailAwal;
  final String noHpAwal;

  const EditProfil({
    super.key,
    required this.namaAwal,
    required this.emailAwal,
    required this.noHpAwal,
  });

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noHpController,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _simpanProfil,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
