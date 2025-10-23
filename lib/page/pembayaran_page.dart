import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Wajib ada
import 'dart:async'; 
import '../model/keranjang_model.dart'; 
import 'pembayaran_success_page.dart'; 

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late Timer _timer;
  int _remainingSeconds = 86400; 
  bool _isPaymentComplete = false;
  String _selectedPaymentMethod = 'QRIS'; 

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('payment_timeout'.tr())), 
          );
           Navigator.pop(context); 
        }
      }
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  void _simulatePaymentSuccess() {
    _timer.cancel();
    setState(() {
      _isPaymentComplete = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      KeranjangModel().clear(); // Kosongkan keranjang
      Navigator.pushReplacement( 
        context,
        MaterialPageRoute(builder: (context) => const PembayaranSuccessPage()),
      );
    });
  }
  
  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(double total) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: const Color(0xFFFFFFFF).withAlpha(0x4D))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('total_payment'.tr(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), // ✅ tr()
          Text('Rp${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = KeranjangModel().totalHarga;
    
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          'payment_title'.tr(), // ✅ tr()
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) 
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: const BackButton(color: Colors.white),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ TIMER DAN STATUS
                _buildTimerAndStatus(),

                const SizedBox(height: 24),
                Text(
                  'payment_detail'.tr(), // ✅ tr()
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Divider(color: Colors.white70),
                
                _buildInfoRow('payment_info_items'.tr(), '${KeranjangModel().items.length} jenis kapal'), // ✅ tr()
                _buildInfoRow('payment_info_shipping'.tr(), 'Gratis (Kapal diambil di Pelabuhan)'), // ✅ tr()
                _buildInfoRow('payment_info_admin'.tr(), 'Rp5.000,00'), // ✅ tr()
                const SizedBox(height: 16),

                _buildTotalRow(total + 5000), // Tambahkan biaya admin 5000

                const SizedBox(height: 32),
                
                // ✅ OPSI PEMBAYARAN BARU
                Text(
                  'payment_methods'.tr(), // ✅ tr()
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                
                _buildPaymentOption('QRIS', Icons.qr_code, 'QRIS'),
                _buildPaymentOption('e_wallet_qris'.tr(), Icons.account_balance_wallet, 'E-Wallet'), // ✅ tr()
                _buildPaymentOption('bank_transfer'.tr(), Icons.payment, 'Bank Transfer'), // ✅ tr()

                const Spacer(),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isPaymentComplete ? null : _simulatePaymentSuccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPaymentComplete ? Colors.grey : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: _isPaymentComplete
                        ? const Icon(Icons.check_circle, color: Colors.white, size: 24) // Centang Sukses
                        : Text(
                            'payment_success_button'.tr(), // ✅ tr()
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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

  // ✅ Widget Timer dan Status
  Widget _buildTimerAndStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0033FF).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // ✅ Animasi Loading / Icon Sukses
          _isPaymentComplete
              ? const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 40)
              : const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 3),
                ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'payment_time_limit'.tr(), // ✅ tr()
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  color: _remainingSeconds < 3600 ? Colors.redAccent : Colors.white, // Merah jika sisa 1 jam
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, String method) {
    final isSelected = _selectedPaymentMethod == method;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isSelected ? Colors.lightBlue.withOpacity(0.2) : const Color(0xFFFFFFFF).withAlpha(0x1A),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.greenAccent) : null,
        onTap: () => _selectPaymentMethod(method),
      ),
    );
  }
}