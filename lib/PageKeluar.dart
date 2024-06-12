import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Barang {
  final int id;
  final String nama;
  final String warna;
  final int stok;
  final double harga;
  final String deskripsi;
  final String createdAt;

  Barang({
    required this.id,
    required this.nama,
    required this.warna,
    required this.stok,
    required this.harga,
    required this.deskripsi,
    required this.createdAt,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    double parsedHarga;
    if (json['harga'] is String) {
      parsedHarga = double.tryParse(json['harga']) ?? 0.0;
    } else if (json['harga'] is int) {
      parsedHarga = (json['harga'] as int).toDouble();
    } else {
      parsedHarga = json['harga'] ?? 0.0;
    }

    return Barang(
      id: json['id'],
      nama: json['nama'],
      warna: json['warna'],
      stok: json['stok'],
      harga: parsedHarga,
      deskripsi: json['deskripsi'] ?? 'Tidak ada deskripsi',
      createdAt: json['created_at'] ?? 'Unknown',
    );
  }
}

class PageKeluar extends StatefulWidget {
  @override
  _PageKeluarState createState() => _PageKeluarState();
}

class _PageKeluarState extends State<PageKeluar> {
  late Future<List<Barang>> futureBarang;

  @override
  void initState() {
    super.initState();
    futureBarang = fetchBarang();
  }

  Future<List<Barang>> fetchBarang() async {
    final response = await http.get(
        Uri.parse('https://humane-escargot-willing.ngrok-free.app/api/barang'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((barang) => Barang.fromJson(barang)).toList();
    } else {
      throw Exception('Failed to load barang');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barang Keluar(API Rest)'),
      ),
      body: FutureBuilder<List<Barang>>(
        future: futureBarang,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final barang = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      'Nama: ${barang.nama}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Deskripsi: ${barang.deskripsi}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Warna: ${barang.warna}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Harga: ${barang.harga}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Jumlah: ${barang.stok}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tanggal Pembuatan: ${barang.createdAt}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
