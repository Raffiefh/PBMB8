import 'dart:async';
import 'package:flutter/material.dart';
import 'screen.dart';
import 'base.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _textController;
  late Animation<double> _imageOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _imageOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeIn),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _imageController.forward().whenComplete(() => _textController.forward());

    _startDelay();
  }

  void _startDelay() {
    _timer = Timer(const Duration(seconds: 10), _goToScreen);
  }

  void _goToScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Screen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _goToScreen,
      child: BaseScaffold(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                      Transform.translate(
                        offset: Offset(0, -size.height * 0.035),
                        child: FadeTransition(
                          opacity: _imageOpacity,
                          child: Image.asset(
                            'assets/EHO.png',
                            width: size.width * 0.5,
                            height: size.height * 0.4,
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'WELCOME IN EHO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  fontFamily: 'Poppins', 
                                  fontWeight: FontWeight.w700, 
                                  color: const Color.fromARGB(255, 226, 243, 252),
                                  letterSpacing: 1.8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: size.width * 0.8,
                                child: Text(
                                  'EHO HORENYA BARENG ! HORENYA EVENT !\n GASPOL TERUS !!!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: size.width * 0.031,
                                    color: const Color.fromARGB(255, 226, 243, 252),
                                    height: 1.35,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ),
    );
  }
}
