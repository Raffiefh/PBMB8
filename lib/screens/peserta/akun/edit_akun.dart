import 'package:flutter/material.dart';
import 'package:pbmuas/screens/widgets/flushbar.dart';
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

class _EditAkunState extends State<EditAkun> with TickerProviderStateMixin {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.namaAwal);
    _emailController = TextEditingController(text: widget.emailAwal);
    _noHpController = TextEditingController(text: widget.noHpAwal);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
      password: null,
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
      CustomFlushbar.show(context, message: "Profil berhasil diperbarui", isSuccess: true);
    } else {
      CustomFlushbar.show(context, message: "Gagal memperbarui profil", isSuccess: false);
    }
  }

  Future<void> _showDiscardDialog() async {
    // Check if there are any changes
    bool hasChanges = _namaController.text != widget.namaAwal ||
        _emailController.text != widget.emailAwal ||
        _noHpController.text != widget.noHpAwal;
    
    if (!hasChanges) {
      Navigator.pop(context);
      return;
    }

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
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.orange.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Buang Perubahan?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            'Anda memiliki perubahan yang belum disimpan. Apakah Anda yakin ingin membuang perubahan ini?',
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
                'Lanjut Edit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Buang',
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
    final screenHeight = MediaQuery.of(context).size.height;
    
    return WillPopScope(
      onWillPop: () async {
        await _showDiscardDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'Edit Profil',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _showDiscardDialog(),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header Section
                Container(
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Edit Informasi Profil',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Perbarui informasi profil Anda',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Form Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Form Card
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
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // Nama Field
                                _buildCustomTextField(
                                  controller: _namaController,
                                  label: 'Nama Lengkap',
                                  icon: Icons.person_rounded,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                      return "Nama hanya boleh mengandung huruf dan spasi";
                                    }
                                    if (value.length < 5) {
                                      return "Nama lengkap minimal 5 karakter";
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Email Field
                                _buildCustomTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  icon: Icons.email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return "Format email tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Phone Field
                                _buildCustomTextField(
                                  controller: _noHpController,
                                  label: 'Nomor Telepon',
                                  icon: Icons.phone_rounded,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Nomor telepon tidak boleh kosong';
                                    }
                                    if (value.length < 9) {
                                      return "Nomor telepon minimal 9 karakter";
                                    }
                                    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                                      return "Format nomor telepon tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Save Button
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
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _editProfil,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Menyimpan...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Simpan Perubahan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Cancel Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            child: TextButton(
                              onPressed: _isLoading ? null : () => _showDiscardDialog(),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              child: const Text(
                                'Batal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.blue.shade600,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            errorStyle: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}