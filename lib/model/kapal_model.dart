class Kapal {
  final String nama;
  final String deskripsi;
  final String urlGambar;
  final double harga;
  final String kategori;
  final double rating;
  final double kapasitasTon; 
  final String jenisMesin;
  final double kecepatanMaks; 
  final double panjangKapal; 

  Kapal({
    required this.nama,
    required this.deskripsi,
    required this.urlGambar,
    required this.harga,
    required this.kategori,
    required this.rating,
    required this.kapasitasTon, 
    required this.jenisMesin,
    required this.kecepatanMaks,
    required this.panjangKapal,
  });

  double hitungBiayaOperasional() {
    return harga * 0.05;
  }
}

class KapalPesiar extends Kapal {
  final int jumlahDeck;

  KapalPesiar({
    required super.nama,
    required super.deskripsi,
    required super.urlGambar,
    required super.harga,
    required super.kategori, 
    required super.rating,   
    required super.kapasitasTon,
    required super.jenisMesin,
    required super.kecepatanMaks,
    required super.panjangKapal,
    required this.jumlahDeck,
  });

  @override
  double hitungBiayaOperasional() {
    return (harga * 0.05) + (jumlahDeck * 10000000);
  }
}

class KapalKargo extends Kapal {
  final double kapasitasTonKargo; 

  KapalKargo({
    required super.nama,
    required super.deskripsi,
    required super.urlGambar,
    required super.harga,
    required super.kategori, 
    required super.rating,
    required super.jenisMesin,
    required super.kecepatanMaks,
    required super.panjangKapal,
    required this.kapasitasTonKargo, 
  }) : super(kapasitasTon: kapasitasTonKargo); 
  @override
  double hitungBiayaOperasional() {
    return (harga * 0.05) + (kapasitasTonKargo * 5000000);
  }
}