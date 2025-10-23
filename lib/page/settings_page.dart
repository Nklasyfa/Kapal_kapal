import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  final String username;

  const SettingsPage({super.key, required this.username});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoLocation = false;
  bool _notification = true;
  bool _locationAccess = false;

  List<Map<String, dynamic>> _purchaseHistory = []; 

  List<String> _loginHistory = [];
  
  String _currentLocation = 'Belum diaktifkan';
  
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2);
  
  @override
  void initState() {
    super.initState();
    _loadHistory(); 
    _addLoginHistory(); 
  }


  void _addLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    const String key = 'riwayat_login';
    final now = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(DateTime.now());

    final existingHistoryString = prefs.getString(key);
    List<String> history = [];
    if (existingHistoryString != null) {
      history = (json.decode(existingHistoryString) as List).map((item) => item.toString()).toList();
    }
    
    
    if (history.isEmpty || history.first != now) { 
      history.insert(0, now); 
    }
    await prefs.setString(key, json.encode(history));
    
    
    if(mounted) {
        setState(() {
            _loginHistory = history;
        });
    }
  }

  
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    
   
    const String purchaseKey = 'riwayat_belanja';
    final purchaseHistoryString = prefs.getString(purchaseKey);

    if (purchaseHistoryString != null) {
      setState(() {
        _purchaseHistory = (json.decode(purchaseHistoryString) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      });
    }

    
    const String loginKey = 'riwayat_login';
    final loginHistoryString = prefs.getString(loginKey);

    if (loginHistoryString != null) {
      setState(() {
        _loginHistory = (json.decode(loginHistoryString) as List)
            .map((item) => item.toString())
            .toList();
      });
    }
  }

  
  void _clearPurchaseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('riwayat_belanja');
    setState(() => _purchaseHistory.clear());
  }

  
  void _clearLoginHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('riwayat_login');
    setState(() => _loginHistory.clear());
  }


  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'location_disabled_desc'.tr();
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'location_denied'.tr();
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = 'location_denied_forever'.tr();
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation =
          'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
    });
  }
  
 
  Widget _buildPurchaseItem(Map<String, dynamic> transaction) {
    final items = transaction['items'] as List<dynamic>;
    final itemNames = items.map((item) => item['nama']).join(', ');
    final total = transaction['total'] as double;
    final tanggal = transaction['tanggal'] as String;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.shopping_bag, color: Color(0xFFF2E6EE), size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(itemNames, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Text(formatter.format(total), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Tanggal: $tanggal', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text('Metode: ${transaction['metode']}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const Divider(color: Colors.white10, height: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          tr("settings"),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const SizedBox(height: 20),

              
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                     
                      backgroundColor: const Color(0xFFFFFFFF).withAlpha(0x33),
                      child: const Icon(Icons.person, color: Colors.white, size: 50),
                    ),
                    const SizedBox(height: 10),
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
              const SizedBox(height: 30),
              const Divider(color: Colors.white24),

            
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.white),
                title: Text(tr("auto_location"), style: const TextStyle(color: Colors.white)),
                subtitle: Text(tr("auto_location_desc"),
                    style: const TextStyle(color: Colors.white70)),
                trailing: Switch(
                  value: _autoLocation,
                  onChanged: (value) async {
                    setState(() => _autoLocation = value);
                    if (value) {
                      await _getLocation();
                    } else {
                      setState(() => _currentLocation = 'disabled'.tr());
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white),
                title: Text(tr("notification"), style: const TextStyle(color: Colors.white)),
                trailing: Switch(
                  value: _notification,
                  onChanged: (value) => setState(() => _notification = value),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.map, color: Colors.white),
                title: Text(tr("access_location"), style: const TextStyle(color: Colors.white)), // ✅ tr()
                trailing: Switch(
                  value: _locationAccess,
                  onChanged: (value) => setState(() => _locationAccess = value),
                ),
              ),

              const Divider(color: Colors.white24),
              const SizedBox(height: 10),

          
              Text(
                tr("current_location"),
                style: TextStyle(
                  color: const Color(0xFFFFFFFF).withAlpha(0xE6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(_currentLocation, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),

             
              Text(
                'purchase_history'.tr(), 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF).withAlpha(0x1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _purchaseHistory.isEmpty
                      ? [Text('no_purchase_history'.tr(), style: const TextStyle(color: Colors.white70))] // ✅ tr()
                      : _purchaseHistory
                          .map((transaction) => _buildPurchaseItem(transaction))
                          .toList(),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _clearPurchaseHistory,
                icon: const Icon(Icons.delete_outline),
                label: Text('delete_purchase_history'.tr()), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
            
              Text(
                tr("login_history"),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF).withAlpha(0x1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _loginHistory.isEmpty
                      ? [Text('no_login_history'.tr(), style: const TextStyle(color: Colors.white70))] // ✅ tr()
                      : _loginHistory
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.history,
                                      color: Colors.white70, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(item,
                                        style: const TextStyle(color: Colors.white70)),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(height: 20),

             
              ElevatedButton.icon(
                onPressed: _clearLoginHistory,
                icon: const Icon(Icons.delete_outline),
                label: Text('delete_login_history'.tr()), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),


              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text(tr("language"), style: const TextStyle(color: Colors.white)),
                trailing: DropdownButton<Locale>(
                  value: context.locale,
                  dropdownColor: const Color(0xFF4A00E0),
                  underline: const SizedBox(),
                  iconEnabledColor: const Color.fromARGB(255, 255, 255, 255),
                  items: const [
                    DropdownMenuItem(
                      value: Locale('id', 'ID'),
                      child: Text("Bahasa Indonesia"),
                    ),
                    DropdownMenuItem(
                      value: Locale('en', 'US'),
                      child: Text("English"),
                    ),
                  ],
                  onChanged: (Locale? locale) {
                    if (locale != null) context.setLocale(locale);
                  },
                ),
              ),

              
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.white),
                title: Text(tr("help_center"), style: const TextStyle(color: Colors.white)),
                subtitle: Text(tr("help_description"),
                    style: const TextStyle(color: Colors.white70)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr("help_description")),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}