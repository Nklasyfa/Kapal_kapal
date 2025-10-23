import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'page/login_page.dart';     
import 'page/home_page.dart';      
import 'page/settings_page.dart';  
import 'widget/splash_screen.dart'; 

void main() async {
  // Pastikan binding Flutter sudah diinisialisasi untuk mengakses aset.
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi easy_localization dan format tanggal lokal
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
      path: 'assets/lang', // Folder tempat file JSON
      fallbackLocale: const Locale('id', 'ID'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kapal Lawutt'.tr(), // ✅ tr()
      debugShowCheckedModeBanner: false,
      
      // 🔹 Setting lokal
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // 🔹 Tema dan warna app
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF4A00E0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8E2DE2),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),

      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(username: 'User'),
        '/settings': (context) => const SettingsPage(username: 'User'),
      },
    );
  }
}