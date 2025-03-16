import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redlenshoescleaning/view/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 200.0).animate(_animationController);
    _animationController.forward();

    // Menjalankan fungsi untuk pindah ke halaman berikutnya setelah waktu tertentu
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Tambahkan baris ini
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: _animation.value,
              height: _animation.value,
              child: Image.asset(
                'assets/image/LogoRedlen.png',
                width: 200,
                height: 200,
              ),
            );
          },
        ),
      ),
    );
  }
}
