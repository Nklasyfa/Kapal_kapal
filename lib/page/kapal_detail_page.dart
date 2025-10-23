import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart'; 
import '../model/kapal_model.dart';
import '../model/keranjang_model.dart'; 
import 'pembayaran_page.dart'; 

class KapalDetailPage extends StatelessWidget {
  final Kapal kapal;

  const KapalDetailPage({super.key, required this.kapal});

  Widget _buildSpecItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFFB388FF), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTonnage = NumberFormat.compact().format(kapal.kapasitasTon);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          kapal.nama, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) 
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: true,
      ),
      body: Container(
        // ✅ Gradien Ungu-Biru yang lebih gelap
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B0082), Color(0xFF1A237E)], // Dark Violet ke Dark Indigo
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar utama kapal
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: kapal.urlGambar.startsWith('http')
                      ? Image.network(kapal.urlGambar, fit: BoxFit.cover, height: 250, width: double.infinity,)
                      : Image.asset(kapal.urlGambar, fit: BoxFit.cover, height: 250, width: double.infinity,),
                ),
                const SizedBox(height: 16),

                // Nama kapal & harga
                Text(
                  kapal.nama,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Tampilkan kategori kapal
                Text(
                  '${'category'.tr()}: ${kapal.kategori}', // ✅ tr()
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp${kapal.harga.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Color(0xFFB388FF),
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

              
                Text(
                  'ship_detail_rating'.tr(), 
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                GFRating(
                  color: Colors.amber,
                  borderColor: Colors.white,
                  size: GFSize.MEDIUM,
                  value: kapal.rating,
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),

                
                Text(
                  'ship_detail_specs'.tr(), 
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSpecItem(
                      'Kapasitas Angkut', 
                      '$formattedTonnage Ton', 
                    ),
                    _buildSpecItem(
                      'Panjang Kapal', 
                      '${kapal.panjangKapal.toStringAsFixed(1)} meter',
                    ),
                    _buildSpecItem('Jenis Mesin', kapal.jenisMesin),
                    _buildSpecItem(
                      'Kecepatan Maks', 
                      '${kapal.kecepatanMaks.toStringAsFixed(1)} knot',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                
                Text(
                  'ship_detail_desc'.tr(), 
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  kapal.deskripsi,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),

                const SizedBox(height: 16),

                
                Text(
                  'ship_detail_facilities'.tr(), 
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Kamar penumpang ber-AC\n'
                  '• Ruang makan & bar laut\n'
                  '• Kolam renang dek atas\n'
                  '• Jaringan Wi-Fi satelit\n'
                  '• Sistem navigasi otomatis',
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 24),

             
                Column( 
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          KeranjangModel().addItem(kapal);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${kapal.nama} ' + 'add_to_cart'.tr())), 
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF).withAlpha(0x33),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.shopping_cart_checkout, size: 20),
                        label: Text(
                          'add_to_cart'.tr(), 
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          KeranjangModel().addItem(kapal);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PembayaranPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0033FF),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: const Icon(Icons.payment, size: 20),
                        label: Text(
                          'checkout_now'.tr(), 
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}