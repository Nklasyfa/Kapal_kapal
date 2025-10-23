import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Wajib ada
import '../model/kapal_model.dart';

class UploadKapalPage extends StatefulWidget {
  final Kapal? kapalToEdit;

  const UploadKapalPage({super.key, this.kapalToEdit});

  @override
  State<UploadKapalPage> createState() => _UploadKapalPageState();
}

class _UploadKapalPageState extends State<UploadKapalPage> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _hargaController;
  late TextEditingController _urlGambarController;
  
  String? _selectedCategory;

 
  final List<String> _categories = [
    'Kargo',
    'Pesiar',
    'Tempur',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kapalToEdit?.nama ?? '');
    _deskripsiController = TextEditingController(text: widget.kapalToEdit?.deskripsi ?? '');
    _hargaController = TextEditingController(text: widget.kapalToEdit?.harga.toString() ?? '');
    _urlGambarController = TextEditingController(text: widget.kapalToEdit?.urlGambar ?? '');
    
    _selectedCategory = widget.kapalToEdit?.kategori ?? _categories.first; // Default
  }
  
  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _urlGambarController.dispose();
    super.dispose();
  }

  void _saveKapal() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('select_category_warning'.tr())), // ✅ tr()
      );
      return;
    }
    
    final newKapal = Kapal(
      nama: _namaController.text,
      deskripsi: _deskripsiController.text,
      harga: double.tryParse(_hargaController.text) ?? 0,
      urlGambar: _urlGambarController.text.trim(),
      kategori: _selectedCategory!,
      rating: widget.kapalToEdit?.rating ?? 4.0, 
      kapasitasTon: widget.kapalToEdit?.kapasitasTon ?? 1000.0,
      jenisMesin: widget.kapalToEdit?.jenisMesin ?? 'Diesel Standard',
      kecepatanMaks: widget.kapalToEdit?.kecepatanMaks ?? 25.0,
      panjangKapal: widget.kapalToEdit?.panjangKapal ?? 50.0,
    );
    Navigator.pop(context, newKapal);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.kapalToEdit != null;
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: Text(
          isEditing ? 'edit_ship'.tr() : 'upload_ship'.tr(), // ✅ tr()
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) 
        ),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTextField(_namaController, 'ship_name'.tr()), // ✅ tr()
                  _buildTextField(_deskripsiController, 'ship_description'.tr()), // ✅ tr()
                  _buildTextField(_hargaController, 'ship_price'.tr()), // ✅ tr()
                  _buildTextField(_urlGambarController, 'ship_image_url'.tr()), // ✅ tr()
                  _buildCategoryDropdown(), 
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveKapal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0033FF),
                    ),
                    child: Text(
                      isEditing ? 'save_changes'.tr() : 'save_ship'.tr(), // ✅ tr()
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          
          color: const Color(0xFFFFFFFF).withAlpha(0x1A),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCategory,
            dropdownColor: const Color.fromARGB(255, 19, 51, 177),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            isExpanded: true,
            hint: Text('select_category'.tr(), style: const TextStyle(color: Color(0xFFF2E6EE))), // ✅ tr()
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFF2E6EE)),
          filled: true,
          
          fillColor: const Color(0xFFFFFFFF).withAlpha(0x1A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}