class produk {
  final int id;
  final String nama_barang;
  final int stok;
  final int harga;

  produk(
      {required this.id,
      required this.nama_barang,
      required this.stok,
      required this.harga});

  factory produk.fromJson(Map<String, dynamic> json) {
    return produk(
      id: json['id'],
      nama_barang: json['nama_barang'],
      stok: json['stok'],
      harga: json['harga'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama_barang': nama_barang,
        'stok': stok,
        'harga': harga,
      };
}
