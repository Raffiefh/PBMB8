import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/screens/panitia/akun/edit_akun.dart'; // Pastikan path ini sesuai dengan struktur foldermu

class AkunContent extends StatefulWidget {
  const AkunContent({super.key});

  @override
  State<AkunContent> createState() => _AkunContentState();
}

class _AkunContentState extends State<AkunContent> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    final authVModel = Provider.of<AuthVModel>(context, listen: false);
    _namaController = TextEditingController(text: authVModel.akun?.nama ?? 'Panitia');
    _emailController = TextEditingController(text: authVModel.akun?.email ?? '-');
    _noHpController = TextEditingController(text: authVModel.akun?.noHp ?? '-');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVModel = Provider.of<AuthVModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Akun Saya')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.edit, size: 20, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(child: Text("Ketuk gambar untuk mengubah")),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _namaController.text,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Nama"),
              subtitle: Text(_namaController.text),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: Text(_emailController.text),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Nomor HP"),
              subtitle: Text(_noHpController.text),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAkun(
                      namaAwal: _namaController.text,
                      emailAwal: _emailController.text,
                      noHpAwal: _noHpController.text,
                    ),
                  ),
                );

                if (hasil != null && mounted) {
                  setState(() {
                    _namaController.text = hasil['nama'] ?? _namaController.text;
                    _emailController.text = hasil['email'] ?? _emailController.text;
                    _noHpController.text = hasil['noHp'] ?? _noHpController.text;
                  });
                  // TODO: update backend/viewmodel jika perlu
                }
              },
              child: const Text("Edit Profil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await authVModel.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
