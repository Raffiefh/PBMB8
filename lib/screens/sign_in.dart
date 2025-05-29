import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbmuas/view_models/auth_v_model.dart';
import 'package:pbmuas/helpers/session_helper.dart';
class sign_in extends StatefulWidget {
  const sign_in({super.key});

  @override
  State<sign_in> createState() => _SignInState();
}

class _SignInState extends State<sign_in> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _staySigned = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthVModel>(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFD1E4FF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(3.47),
            colors: [
              Color.fromRGBO(209, 228, 255, 1),
              Color.fromRGBO(153, 250, 255, 1),
              Color.fromRGBO(102, 186, 255, 1),
              Color.fromRGBO(69, 177, 255, 1),
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: height * 0.70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gmail",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: width * 0.04,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'masukkan gmail anda',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: width * 0.035,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 188, 188, 188),
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
                    SizedBox(height: height * 0.03),
                    Text(
                      "Password",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: width * 0.04,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'masukkan password anda',
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
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: width * 0.032,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: height * 0.065,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              0,
                              102,
                              204,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            final auth = Provider.of<AuthVModel>(
                              context,
                              listen: false,
                            );
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Email dan password harus diisi!',
                                  ),
                                  duration: Duration(seconds: 5),
                                ),
                              );
                              return;
                            }
                            try {
                             final success = await auth.login(
                                _emailController.text,
                                _passwordController.text,
                                _staySigned,
                              );
                              // Debug: Cek state terakhir
                                print('Login success: $success');
                                print('Akun setelah login: ${auth.akun?.toJson()}');
                                print('Token setelah login: ${await SessionHelper.getToken()}');
                              if (success) {
                                // Tambahkan delay kecil untuk memastikan state terupdate
                                await Future.delayed(const Duration(milliseconds: 50));
                                final user = auth.akun ?? await SessionHelper.getUser();
                                if (user == null) {
                                  print('ERROR: User null padahal login sukses');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gagal memuat data user')),
                                  );
                                  return;
                                }

                                print('Role ID: ${user.roleAkunId}');
                                switch (user.roleAkunId) {
                                  case 1:
                                    Navigator.pushReplacementNamed(context, '/panitia');
                                    break;
                                  case 2:
                                    Navigator.pushReplacementNamed(context, '/peserta');
                                    break;
                                  default:
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Role user tidak dikenali')),
                                    );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login gagal')),
                                );
                              }
                              // ... lanjutan flow
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.toString()}')),
                              );
}
                          },
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
                          children: const [
                            TextSpan(text: "Tidak memiliki Akun? "),
                            TextSpan(
                              text: "SIGN UP",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.08,
              left: width * 0.06,
              child: Text(
                "Hello\nSign in!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: width * 0.075,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
