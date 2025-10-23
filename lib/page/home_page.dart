import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/kapal_model.dart';
import 'kapal_detail_page.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import '../widget/video_background.dart';
import 'package:video_player/video_player.dart';
import 'settings_page.dart';
import 'keranjang_page.dart'; 

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Kapal> _allKapal = [
    Kapal(
      nama: 'Ngawii Destroyer',
      deskripsi: 'Kapal buatan ngawi yang siap bertempur di segala medan laut.',
      urlGambar: 'assets/images/gambar1.jpg',
      harga: 1500000000,
      kategori: 'Tempur',
      rating: 4.8,
      kapasitasTon: 800.0,
      jenisMesin: 'Turbin Gas T-100',
      kecepatanMaks: 55.5,
      panjangKapal: 125.0,
    ),
    Kapal(
      nama: 'Flying Dutchman',
      deskripsi: 'Kapal kargo besar yang mampu mengangkut ribuan kontainer.',
      urlGambar: 'assets/images/gambar2.jpg',
      harga: 3500000000,
      kategori: 'Kargo',
      rating: 4.5,
      kapasitasTon: 150000.0,
      jenisMesin: 'Diesel Low-Speed Sulzer',
      kecepatanMaks: 28.0,
      panjangKapal: 350.0,
    ),
    Kapal(
      nama: 'Sea Serpent',
      deskripsi: 'Kapal layar canggih yang menggunakan teknologi angin dan keringat',
      urlGambar: 'assets/images/gambar3.jpg',
      harga: 5000000000,
      kategori: 'Pesiar',
      rating: 4.2,
      kapasitasTon: 50000.0,
      jenisMesin: 'Diesel Elektrik Wärtsilä',
      kecepatanMaks: 40.0,
      panjangKapal: 200.0,
    ),
    Kapal(
      nama: 'Rohignya Voyagerr',
      deskripsi: 'Kapal Balap dengan kemegahan dan kemewahan di dalam nya',
      urlGambar: 'assets/images/gambar4.jpg',
      harga: 5000000000,
      kategori: 'Pesiar',
      rating: 4.9,
      kapasitasTon: 50000.0,
      jenisMesin: 'Mesin Supera',
      kecepatanMaks: 40.0,
      panjangKapal: 200.0,
    ),
    Kapal(
      nama: 'Adudu Sky Piercer',
      deskripsi: 'Kapal terbang yang siap terbang kemana saja.',
      urlGambar: 'assets/images/gambar5.jpg',
      harga: 5000000000,
      kategori: 'Tempur',
      rating: 4.9,
      kapasitasTon: 50000.0,
      jenisMesin: 'Diesel Elektrik Wärtsilä',
      kecepatanMaks: 40.0,
      panjangKapal: 200.0,
    ),
    Kapal(
      nama: 'Sea Moby',
      deskripsi: 'Kapal selam canggih untuk penelitian di laut dalam.',
      urlGambar: 'assets/images/gambar6.jpg',
      harga: 5000000000,
      kategori: 'Tempur',
      rating: 4.2,
      kapasitasTon: 50000.0,
      jenisMesin: 'Diesel Elektrik Wärtsilä',
      kecepatanMaks: 40.0,
      panjangKapal: 200.0,
    ),
    Kapal(
      nama: 'Pesiarera',
      deskripsi: 'Kapal pesiar terbesar dunia dengan fasilitas mewah.',
      urlGambar: 'assets/images/gambar7.jpg',
      harga: 5000000000,
      kategori: 'Pesiar',
      rating: 4.2,
      kapasitasTon: 50000.0,
      jenisMesin: 'Diesel Elektrik Wärtsilä',
      kecepatanMaks: 40.0,
      panjangKapal: 200.0,
    ),
    Kapal(
      nama: 'The duck',
      deskripsi: 'Kapal amfibi pertama di Ngawi',
      urlGambar: 'assets/images/gambar8.jpg',
      harga: 5000000000,
      kategori: 'Tempur',
      rating: 4.2,
      kapasitasTon: 50000.0,
      jenisMesin: 'Diesel Elektrik Wärtsilä',
      kecepatanMaks: 40.0,
      panjangKapal: 200.0,
    ),
  ];

  List<Kapal> _filteredKapal = [];
  final TextEditingController _searchController = TextEditingController();

  
  String _selectedCategory = 'Semua';

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoFuture;

  @override
  void initState() {
    super.initState();
    _filteredKapal = _allKapal;
    _searchController.addListener(_filterKapal);

    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/bg1.mp4');
    _initializeVideoFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterKapal);
    _searchController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }


  void _filterKapal() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredKapal = _allKapal.where((kapal) {
        final isMatchQuery = kapal.nama.toLowerCase().contains(query) ||
            kapal.deskripsi.toLowerCase().contains(query);
        
        final isMatchCategory = _selectedCategory == 'Semua' ||
            (_selectedCategory == 'Populer' && kapal.rating >= 4.5) || 
            (_selectedCategory == 'Baru' && _isNew(kapal)) || 
            (kapal.kategori == _selectedCategory);

        return isMatchQuery && isMatchCategory;
      }).toList();
    });
  }
  

  bool _isNew(Kapal kapal) {
    return !_allKapal.sublist(0, 3).contains(kapal);
  }


  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterKapal();
    });
  }

  void _navigateToDashboard() async {
    final updatedList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(daftarKapal: _allKapal),
      ),
    );

    if (updatedList != null && updatedList is List<Kapal>) {
      setState(() {
        _allKapal = updatedList;
        _filterKapal();
      });
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(username: widget.username),
      ),
    );
  }

 
  Widget _buildGambar(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
            color: Colors.white, size: 60),
      );
    } else {
      return Image.asset(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
            color: Colors.white, size: 60),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          'Beranda Kapal'.tr(), 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) 
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.white), 
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KeranjangPage()),
          );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0033FF),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF977DFF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFFFFFFF).withAlpha(0x33),
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title:
                  Text('home'.tr(), style: const TextStyle(color: Colors.white)), 
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: Text('dashboard_title'.tr(),
                  style: const TextStyle(color: Colors.white)), 
              onTap: () {
                Navigator.pop(context);
                _navigateToDashboard();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text('settings'.tr(),
                  style: const TextStyle(color: Colors.white)), 
              onTap: () {
                Navigator.pop(context);
                _navigateToSettings();
              },
            ),
            const Divider(color: Colors.white70),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title:
                  Text('logout'.tr(), style: const TextStyle(color: Colors.white)), 
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _initializeVideoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return VideoBackground(
              controller: _videoPlayerController,
              child: _buildHomePageContent(context),
            );
          } else {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF977DFF), Color(0xFF0033FF)],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHomePageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: kToolbarHeight + 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Halo, ${widget.username}!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF2E6EE),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            'find_your_ship'.tr(), 
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFF2E6EE),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'search_ship'.tr(), 
              labelStyle: const TextStyle(color: Color(0xFFF2E6EE)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF977DFF)),
              filled: true,
              fillColor: const Color(0xFFFFFFFF).withAlpha(0x1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // ✅ Icon Kategori yang bisa diklik
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconItem(Icons.public, 'category_all'.tr(), 'Semua'), 
                _buildIconItem(Icons.star, 'category_popular'.tr(), 'Populer'), 
                _buildIconItem(Icons.alarm_add, 'category_new'.tr(), 'Baru'), 
                _buildIconItem(Icons.local_shipping, 'category_kargo'.tr(), 'Kargo'), 
                _buildIconItem(Icons.sailing, 'category_pesiar'.tr(), 'Pesiar'), 
                _buildIconItem(Icons.local_fire_department, 'category_tempur'.tr(), 'Tempur'), 
              ].map((w) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: w,
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // ✅ Label Kategori yang dipilih
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            '${'category'.tr()}: ${_selectedCategory}', 
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFF2E6EE),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filteredKapal.length,
            itemBuilder: (context, index) {
              final kapal = _filteredKapal[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KapalDetailPage(kapal: kapal),
                    ),
                  );
                },
                child: Card(
                  elevation: 10,
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
                              Text(
                                kapal.nama,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                kapal.deskripsi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp${kapal.harga.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFF2E6EE),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ✅ Tampilkan Rating
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    kapal.rating.toStringAsFixed(1),
                                    style: const TextStyle(color: Colors.amber),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ _buildIconItem yang diperbarui dan bisa diklik
  Widget _buildIconItem(IconData icon, String label, String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0033FF).withOpacity(0.8) 
                  : const Color(0xFFFFFFFF).withAlpha(0x1A),
              borderRadius: BorderRadius.circular(50),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label, // Label sudah diterjemahkan di pemanggil
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}