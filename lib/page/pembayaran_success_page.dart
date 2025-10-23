import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/kapal_model.dart';


class PembayaranSuccessPage extends StatelessWidget {
  const PembayaranSuccessPage({super.key});

  
  static final dummyItems = [
    Kapal(
      nama: 'Ngawii Destroyer', deskripsi: '', urlGambar: '', harga: 1500000000, kategori: 'Tempur', rating: 4.8, kapasitasTon: 800.0, jenisMesin: 'Turbin Gas T-100', kecepatanMaks: 55.5, panjangKapal: 125.0,
    ),
  ];
  static const double biayaAdmin = 5000.00;
  static final double dummySubtotal = dummyItems.first.harga;
  static final double dummyTotal = dummySubtotal + biayaAdmin;
  
  
  Future<void> _saveTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    const String key = 'riwayat_belanja';
    
    
    final newTransaction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'tanggal': DateFormat('EEEE, dd MMMM yyyy HH:mm').format(DateTime.now()),
      'items': dummyItems.map((k) => {'nama': k.nama, 'harga': k.harga, 'qty': 1}).toList(),
      'total': dummyTotal,
      'metode': 'Simulasi QRIS/E-Wallet',
    };
    
    final existingHistoryString = prefs.getString(key);
    List<Map<String, dynamic>> history = [];
    if (existingHistoryString != null) {
      history = (json.decode(existingHistoryString) as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    }
  
    
    history.insert(0, newTransaction); 
    
    
    await prefs.setString(key, json.encode(history));
  }


  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: context.locale.toString(), symbol: 'Rp', decimalDigits: 2); // Menggunakan locale kontekstual
    
   
    _saveTransaction();
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('receipt_title'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // ✅ tr()
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF977DFF), Color(0xFF0033FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                    const SizedBox(height: 16),
                    Text('receipt_success_message'.tr(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)), // ✅ tr()
                    const SizedBox(height: 8),
                    Text('Transaksi ID: TX${DateTime.now().millisecondsSinceEpoch}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),

                    _buildStrukHeader('receipt_summary'.tr()), // ✅ tr()
                    ...dummyItems.map((k) => _buildStrukItem(k.nama, k.harga, 1, formatter)).toList(),
                    
                    const Divider(height: 20, color: Colors.grey),
                    _buildStrukFooter('payment_info_admin'.tr(), formatter.format(biayaAdmin)), // ✅ tr()
                    _buildStrukFooter('total_payment'.tr(), formatter.format(dummyTotal), isTotal: true), // ✅ tr()
                    const Divider(height: 20, color: Colors.grey),
                    
                    _buildStrukHeader('receipt_method'.tr()), // ✅ tr()
                    _buildStrukFooter('Metode', 'Simulasi QRIS/E-Wallet'),
                    _buildStrukFooter('Waktu Transaksi', DateFormat('HH:mm:ss, dd MMMM yyyy').format(DateTime.now())),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                       
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0033FF),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('receipt_back_home'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16)), // ✅ tr()
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrukHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildStrukItem(String nama, double harga, int qty, NumberFormat formatter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('$nama (x$qty)', style: const TextStyle(color: Colors.black))),
          Text(formatter.format(harga * qty), style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
  
  Widget _buildStrukFooter(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: Colors.black)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}