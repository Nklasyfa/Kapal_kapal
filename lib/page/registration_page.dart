import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';
import 'login_page.dart';
import '../widget/video_background.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/bg2.mp4');
    _initializeVideoFuture = _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi tidak cocok!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1600));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registeredUsername', username);
    await prefs.setString('registeredPassword', password);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Akun "$username" berhasil didaftarkan!'),
        backgroundColor: Colors.green,
      ),
    );

    // Balik ke login page pake transisi halus
    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          ),
        ),
      );
    });
  }

  void _goBackToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initializeVideoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return VideoBackground(
              controller: _videoController,
              child: _isLoading
                  ? const Center(
                      child: GFLoader(
                        type: GFLoaderType.circle,
                        size: 70.0,
                        loaderColorOne: Color(0xFF977DFF),
                        loaderColorTwo: Color(0xFF0033FF),
                      ),
                    )
                  : Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_rounded,
                              size: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'DAFTAR AKUN',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 60),
                            _buildTextField(
                              controller: _usernameController,
                              label: 'Nama Pengguna',
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Kata Sandi',
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Konfirmasi Kata Sandi',
                              isConfirmPassword: true,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF977DFF),
                                      Color(0xFF0033FF)
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'DAFTAR',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _goBackToLogin,
                              child: const Text(
                                'Kembali ke Login',
                                style: TextStyle(
                                  color: Color(0xFFF2E6EE),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFF2E6EE),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          } else {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF977DFF), Color(0xFF0033FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: GFLoader(
                  type: GFLoaderType.circle,
                  size: 60.0,
                  loaderColorOne: Color(0xFF977DFF),
                  loaderColorTwo: Color(0xFF0033FF),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: (isPassword && !_isPasswordVisible) ||
          (isConfirmPassword && !_isConfirmPasswordVisible),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFF2E6EE)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: (isPassword || isConfirmPassword)
            ? IconButton(
                icon: Icon(
                  (isPassword && _isPasswordVisible) ||
                          (isConfirmPassword && _isConfirmPasswordVisible)
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (isPassword) {
                      _isPasswordVisible = !_isPasswordVisible;
                    } else {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    }
                  });
                },
              )
            : null,
      ),
    );
  }
}
