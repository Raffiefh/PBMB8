import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'sign_in.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _SignUpState();
}

class _SignUpState extends State<sign_up> {
  bool _isObscure = true;
  String _selectedRole = 'User';

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(left: width * 0.06, top: height * 0.08),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Nama Lengkap", width),
                        _buildTextField("Masukkan nama lengkap"),

                        SizedBox(height: height * 0.015),
                        _buildLabel("Email", width),
                        _buildTextField("Masukkan email"),

                        SizedBox(height: height * 0.015),
                        _buildLabel("Username", width),
                        _buildTextField("Masukkan username"),

                        SizedBox(height: height * 0.015),
                        _buildLabel("Password", width),
                        TextField(
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: 'Masukkan password',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: width * 0.035,
                            ),
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure ? Icons.visibility_off : Icons.visibility,
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
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.015),
                        _buildLabel("No. Telepon", width),
                        _buildTextField("Masukkan nomor telepon", keyboardType: TextInputType.phone),

                        SizedBox(height: height * 0.025),
                        _buildLabel("Daftar sebagai", width),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'User',
                              groupValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                            const Text('User'),

                            Radio<String>(
                              value: 'Penyelenggara',
                              groupValue: _selectedRole,
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0066CC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // Simpan data ke database / Firebase / Backend
                              // Lalu navigasi ke login
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const sign_in()),
                              );
                            },
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const sign_in()),
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

  Widget _buildTextField(String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Poppins'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
