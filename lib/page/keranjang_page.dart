import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Wajib ada
import '../model/keranjang_model.dart';
import 'pembayaran_page.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final keranjang = KeranjangModel();

  void _update() {
    // Memaksa rebuild untuk update total dan list
    setState(() {}); 
  }
  
  void _removeItem(KeranjangItem item) {
    keranjang.removeItem(item.kapal);
    _update();
  }

  void _navigateToPayment() {
    if (keranjang.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('empty_cart'.tr())), // ✅ tr()
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PembayaranPage()),
    ).then((_) {
      // Refresh setelah kembali dari halaman pembayaran (untuk update keranjang kosong)
      _update();
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = keranjang.items;
    final total = keranjang.totalHarga;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          'cart_title'.tr(), // ✅ tr()
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) 
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF977DFF), Color(0xFF0033FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? Center( 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.white54),
                            const SizedBox(height: 16),
                            Text(
                              'cart_empty_message'.tr(), // ✅ tr()
                              style: const TextStyle(fontSize: 20, color: Colors.white70),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _buildCartItem(item, _removeItem);
                        },
                      ),
              ),
              
              // Footer Total dan Tombol Bayar
              _buildCheckoutFooter(total, _navigateToPayment),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Item Keranjang Diperbesar
  Widget _buildCartItem(KeranjangItem item, Function(KeranjangItem) onRemove) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15), 
      color: const Color(0xFFFFFFFF).withAlpha(0x1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
      child: Padding(
        padding: const EdgeInsets.all(12.0), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              // Gambar diperbesar
              child: item.kapal.urlGambar.startsWith('http')
                  ? Image.network(item.kapal.urlGambar, width: 100, height: 100, fit: BoxFit.cover)
                  : Image.asset(item.kapal.urlGambar, width: 100, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15), // Jarak lebih besar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.kapal.nama,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), // Font lebih besar
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${'category'.tr()}: ${item.kapal.kategori}', // ✅ tr()
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(color: Color(0xFFF2E6EE), fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        'Rp${item.subtotal.toStringAsFixed(2)}', // Subtotal di sisi kanan
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton( 
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => onRemove(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutFooter(double total, VoidCallback onCheckout) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xFF0033FF),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'total_price'.tr(), // ✅ tr()
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                'Rp${total.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'continue_to_payment'.tr(), // ✅ tr()
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}