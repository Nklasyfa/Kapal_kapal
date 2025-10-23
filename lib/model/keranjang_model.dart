import 'kapal_model.dart';

class KeranjangItem {
  final Kapal kapal;
  int quantity; 

  KeranjangItem({required this.kapal, this.quantity = 1}); 

  double get subtotal => kapal.harga * quantity;
}

class KeranjangModel {
  
  static final KeranjangModel _instance = KeranjangModel._internal();
  factory KeranjangModel() => _instance;
  KeranjangModel._internal();

  final List<KeranjangItem> _items = [];
  List<KeranjangItem> get items => _items;

  double get totalHarga {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void addItem(Kapal kapal) {
    final existingItemIndex = _items.indexWhere((item) => item.kapal.nama == kapal.nama);
    
    if (existingItemIndex != -1) {
      
      _items[existingItemIndex].quantity++;
    } else {
      
      _items.add(KeranjangItem(kapal: kapal, quantity: 1));
    }
  }

  void removeItem(Kapal kapal) {
    _items.removeWhere((item) => item.kapal.nama == kapal.nama);
  }
  
  void clear() {
    _items.clear();
  }
  
  // ✅ METHOD BARU: Mendapatkan ringkasan transaksi untuk disimpan
  List<Map<String, dynamic>> get transactionSummary {
    return _items.map((item) => {
      'nama': item.kapal.nama,
      'harga': item.kapal.harga,
      'qty': item.quantity,
      'subtotal': item.subtotal,
      'tanggal': DateTime.now().toIso8601String(),
    }).toList();
  }
}