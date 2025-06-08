import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pbmuas/models/akun.dart';
import 'sign_in.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _SignUpState();
}

class _SignUpState extends State<sign_up> {
  bool _isObscure = true;
  bool _isLoading = false;
  String _selectedRole = '2';
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noHpController = TextEditingController();
  void _tampilanPesanSuccess() {
    Flushbar(
      messageText: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Registrasi berhasil, silahkan login",
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

  void _register() async {
   
    if (!_formKey.currentState!.validate()) return;
    final role = int.tryParse(_selectedRole) ?? 0;
    setState(() => _isLoading = true);
    
    final akunBaru = Akun(
      nama: _namaController.text,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      noHp: _noHpController.text,
      roleAkunId: role,
    );

    final auth = Provider.of<AuthVModel>(context, listen: false);
    final String? errorMessage = await auth.register(akunBaru);
    setState(() => _isLoading = false);
    if (errorMessage == null) {
      Navigator.pushReplacementNamed(context, '/login');
      _tampilanPesanSuccess();
      
    } else {
      Flushbar(
        messageText: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white), // Ganti ikon untuk error
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessage, // Tampilkan pesan error dari backend
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent, // Ganti warna untuk error
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
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthVModel>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                transform: GradientRotation(3.274),
                colors: [
                  Color.fromRGBO(194, 219, 255, 1),
                  Color(0xFF66BAFF),
                  Color(0xFF45B1FF),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),

          Column(
            children: [
              Container(
                height: height * 0.22,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: width * 0.06,
                  top: height * 0.08,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome\nCreate Your Account",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.1,
                    vertical: height * 0.03,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Nama Lengkap", width),
                          SizedBox(height: height * 0.01),
                          _buildTextField(
                            "Masukkan nama lengkap",
                            width,
                            controller: _namaController,
                            prefixIcon: Icons.contact_emergency_outlined,
                            validator: (value) {
                              final nama = _namaController.text;
                              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nama)) {
                                return "Nama hanya boleh mengandung huruf dan spasi.";
                              }
                              if (nama.length < 5) {
                                return "Nama lengkap minimal 5 karakter";
                              }
                            },
                          ),

                          SizedBox(height: height * 0.015),
                          _buildLabel("Email", width),
                          SizedBox(height: height * 0.01),
                          _buildTextField(
                            "Masukkan email",
                            width,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (value){
                              final email = _emailController.text;
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                                return "Format email tidak valid";
                              }
                            }
                          ),

                          SizedBox(height: height * 0.015),
                          _buildLabel("Username", width),
                          SizedBox(height: height * 0.01),
                          _buildTextField(
                            "Masukkan username",
                            width,
                            controller: _usernameController,
                            prefixIcon: Icons.person_outlined,
                             validator: (value){
                              final username = _usernameController.text;
                              if (username.contains(' ')) {
                                return "Username tidak boleh mengandung spasi.";
                              }
                              if (username.length < 5) {
                                return "Username minimal 5 karakter";
                              }
                            }
                          ),

                          SizedBox(height: height * 0.015),
                          _buildLabel("Password", width),
                          SizedBox(height: height * 0.01),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Masukan password tidak boleh kosong";
                              }
                              if (value.length < 8) {
                                return "Password minimal 8 karakter";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan password',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: width * 0.035,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFBCBCBC),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.015),
                          _buildLabel("No. Telepon", width),
                          SizedBox(height: height * 0.01),
                          _buildTextField(
                            "Masukkan nomor telepon",
                            width,
                            controller: _noHpController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_outlined,
                            validator: (value){
                              final noHp = _noHpController.text;
                              if (!RegExp(r'^[0-9]+$').hasMatch(noHp)) {
                                return "Nomor telepon hanya boleh mengandung angka.";
                              }
                              if (noHp.length < 9) {
                                return "Nomor telepon minimal 10 angka";
                              }
                            }
                          ),

                          SizedBox(height: height * 0.025),
                          _buildLabel("Daftar sebagai", width),
                          Row(
                            children: [
                              Radio<String>(
                                value: '2',
                                groupValue: _selectedRole,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                              const Text('User'),

                              Radio<String>(
                                value: '1',
                                groupValue: _selectedRole,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                              const Text('Penyelenggara'),
                            ],
                          ),

                          SizedBox(height: height * 0.03),
                          SizedBox(
                            width: double.infinity,
                            height: height * 0.065,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _register,
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
                                        'SIGN UP',
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

                          SizedBox(height: height * 0.02),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: width * 0.03,
                                  color: Colors.black54,
                                ),
                                children: [
                                  const TextSpan(text: "Sudah punya akun? "),
                                  TextSpan(
                                    text: "SIGN IN",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const sign_in(),
                                              ),
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, double width) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: width * 0.04,
        color: Colors.blue,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    double width, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    Color? iconColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
        hintText: hint,
        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: width * 0.035),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBCBCBC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
