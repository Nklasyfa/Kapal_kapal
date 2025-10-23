import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Wajib ada
import '../model/kapal_model.dart';
import 'upload_kapal_page.dart';

class DashboardPage extends StatefulWidget {
  final List<Kapal> daftarKapal;

  const DashboardPage({super.key, required this.daftarKapal});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Kapal> _uploadedKapal;

  @override
  void initState() {
    super.initState();
    _uploadedKapal = List.from(widget.daftarKapal);
  }

  void _addOrUpdateKapal(Kapal newKapal, {int? index}) {
    setState(() {
      if (index == null) {
        _uploadedKapal.add(newKapal);
      } else {
        _uploadedKapal[index] = newKapal;
      }
    });
  }

  void _hapusKapal(int index) {
    setState(() {
      _uploadedKapal.removeAt(index);
    });
  }

  Widget _buildGambar(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.white, size: 70),
      );
    } else if (path.isNotEmpty) {
      return Image.asset(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, color: Colors.white, size: 70),
      );
    } else {
      return const Icon(Icons.image_not_supported,
          color: Colors.white, size: 70);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          'dashboard_title'.tr(), // ✅ tr()
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) 
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, _uploadedKapal),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final newKapal = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadKapalPage(),
                ),
              );
              if (newKapal != null) _addOrUpdateKapal(newKapal);
            },
          ),
        ],
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _uploadedKapal.length,
            itemBuilder: (context, index) {
              final kapal = _uploadedKapal[index];
              return Card(
                elevation: 8,
                color: const Color(0xFFFFFFFF).withAlpha(0x1A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildGambar(kapal.urlGambar),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(kapal.nama,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(kapal.deskripsi,
                                style:
                                    const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 8),
                            Text('Rp${kapal.harga.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFF2E6EE),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () async {
                              final hasilEdit = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                    // Menggunakan UploadKapalPage yang sudah diubah ke i18n
                                    UploadKapalPage(kapalToEdit: kapal),
                                ),
                              );
                              if (hasilEdit != null) {
                                _addOrUpdateKapal(hasilEdit, index: index);
                              }
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _hapusKapal(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}