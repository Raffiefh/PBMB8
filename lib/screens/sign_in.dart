import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../view/navigasi_user.dart';
import 'sign_up.dart';
import 'lupa_password.dart';

class sign_in extends StatefulWidget {
  const sign_in({super.key});

  @override
  State<sign_in> createState() => _SignInState();
}

class _SignInState extends State<sign_in> {
  bool _isObscure = true;

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
                height: height * 0.25,
                width: double.infinity,
                padding: EdgeInsets.only(left: width * 0.06, top: height * 0.08),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hello\nEHO Friends",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: width * 0.075,
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
                    vertical: height * 0.04,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: width * 0.072,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 60, 119),
                          ),
                        ),
                        SizedBox(height: height * 0.02),

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
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Masukkan gmail anda',
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: width * 0.035,
                            ),
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFBCBCBC)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
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
                        TextField(
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: 'Masukkan password anda',
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
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.015),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const lupa_password()),
                              );
                            },
                            child: Text(
                              'Lupa Password?',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: width * 0.032,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.035),

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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const NavigasiUser()),
                              );
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
                                const TextSpan(text: "Tidak memiliki akun? "),
                                TextSpan(
                                  text: "SIGN UP",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const sign_up()),
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
}