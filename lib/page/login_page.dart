import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart'; // Wajib ada
import 'home_page.dart';
import 'registration_page.dart';
import '../widget/video_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  // bool _isLoading = false; // ✅ DIHAPUS: State loading tidak digunakan lagi

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/bg2.mp4');

    _initializeVideoFuture = _videoPlayerController.initialize().then((_) async {
      _videoPlayerController.setLooping(true);
      await Future.delayed(const Duration(milliseconds: 200));
      _videoPlayerController.play();
      setState(() {});
    });

    _loadStoredUsername();
  }

  Future<void> _loadStoredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('loggedInUsername');
    if (storedUsername != null) {
      _usernameController.text = storedUsername;
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUsername', username);
  }

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama pengguna dan kata sandi tidak boleh kosong'),
        ),
      );
      return;
    }

    // setState(() { _isLoading = true; }); // ✅ DIHAPUS
    // await Future.delayed(const Duration(milliseconds: 1800)); // ✅ DIHAPUS DELAY
    // setState(() { _isLoading = false; }); // ✅ DIHAPUS

    await _saveUsername(username);

    // Navigasi ke HomePage dengan transisi fade smooth
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => HomePage(username: username),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _register() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const RegistrationPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
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
              controller: _videoPlayerController,
              child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.sailing,
                              size: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'KAPAL LAWUTT',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 60),
                            Text(
                              'welcome'.tr(), 
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF2E6EE),
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildTextField(
                              controller: _usernameController,
                              label: 'username'.tr(), 
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'password'.tr(), 
                              isPassword: true,
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
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'login'.tr(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _register,
                              child: const Text(
                                'Daftar Akun Baru',
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
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFF2E6EE)),
        filled: true,
        fillColor: const Color(0xFFFFFFFF).withAlpha(0x26), // 0.15
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      obscureText: isPassword && !_isPasswordVisible,
    );
  }
}