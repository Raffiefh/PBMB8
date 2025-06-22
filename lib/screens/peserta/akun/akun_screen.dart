import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbmuas/screens/widgets/flushbar.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/screens/peserta/akun/edit_akun.dart';

class AkunPeserta extends StatefulWidget {
  const AkunPeserta({super.key});

  @override
  State<AkunPeserta> createState() => _AkunPesertaState();
}

class _AkunPesertaState extends State<AkunPeserta> with TickerProviderStateMixin {
  File? _profileImage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
      await _uploadFotoBaru(); 
    }
  }

  Future<void> _uploadFotoBaru() async {
    if (_profileImage == null) return;

    final authVModel = Provider.of<AuthVModel>(context, listen: false);
    final akun = authVModel.akun;

    if (akun == null || akun.id == null) return;

    final berhasil = await authVModel.uploadFotoProfil(_profileImage!);
    if (berhasil) {
      CustomFlushbar.show(context, message: "Foto berhasil diunggah", isSuccess: true);
      setState(() {}); 
    } else {
      CustomFlushbar.show(context, message: "Gagal mengunggah foto", isSuccess: false);
    }
  }

  Future<void> _showLogoutDialog() async {
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authVModel = Provider.of<AuthVModel>(context, listen: false);
                await authVModel.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVModel = Provider.of<AuthVModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Akun Saya',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Curved Background
              Container(
                height: screenHeight * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade400,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : (authVModel.akun?.profilUrl != null && authVModel.akun!.profilUrl!.isNotEmpty)
                                    ? NetworkImage(authVModel.akun!.profilUrl!)
                                    : null,
                            child: _profileImage == null && (authVModel.akun?.profilUrl == null || authVModel.akun!.profilUrl!.isEmpty)
                                ? Icon(Icons.person_rounded, size: 70, color: Colors.blue.shade300)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.blue.shade600,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      authVModel.akun?.username ?? 'Panitia',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ketuk foto untuk mengubah',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile Information Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoTile(
                            icon: Icons.person_rounded,
                            title: "Nama",
                            subtitle: authVModel.akun?.nama ?? 'Panitia',
                            isFirst: true,
                          ),
                          const Divider(height: 1, indent: 70),
                          _buildInfoTile(
                            icon: Icons.email_rounded,
                            title: "Email",
                            subtitle: authVModel.akun?.email ?? '-',
                          ),
                          const Divider(height: 1, indent: 70),
                          _buildInfoTile(
                            icon: Icons.phone_rounded,
                            title: "Nomor HP",
                            subtitle: authVModel.akun?.noHp ?? '-',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Action Buttons
                    Column(
                      children: [
                        // Edit Profile Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.blue.shade500],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final hasil = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAkun(
                                    namaAwal: authVModel.akun?.nama ?? 'Panitia',
                                    emailAwal: authVModel.akun?.email ?? '-',
                                    noHpAwal: authVModel.akun?.noHp ?? '-',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded, size: 20),
                            label: const Text(
                              "Edit Profil",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Logout Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _showLogoutDialog,
                            icon: const Icon(Icons.logout_rounded, size: 20),
                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isFirst ? 20 : 0),
          topRight: Radius.circular(isFirst ? 20 : 0),
          bottomLeft: Radius.circular(isLast ? 20 : 0),
          bottomRight: Radius.circular(isLast ? 20 : 0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
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
