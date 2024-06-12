import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PetaPage extends StatefulWidget {
  const PetaPage({Key? key}) : super(key: key);

  @override
  _PageMapState createState() => _PageMapState();
}

class _PageMapState extends State<PetaPage> {
  List<Map<String, dynamic>> barangData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang Masuk(API Rest)'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBarangList(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildBarangList() {
    return Column(
      children: barangData.map((barang) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
              'Nama: ${barang['nama']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Deskripsi: ${barang['deskripsi'] ?? 'Tidak ada deskripsi'}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  'Harga: ${barang['harga']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Jumlah: ${barang['stok']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Created At: ${barang['created_at']}', // Tambahkan ini untuk menampilkan createdAt
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void getData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://humane-escargot-willing.ngrok-free.app/api/products'),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body)['data'];
        List<Map<String, dynamic>> newData = [];

        for (var data in responseData) {
          newData.add({
            'id': data['id'],
            'nama': data['nama'],
            'deskripsi': data['deskripsi'],
            'harga': data['harga'],
            'stok': data['stok'],
            'created_at': data['created_at'], // Tambahkan ini untuk createdAt
          });
        }

        setState(() {
          barangData = newData;
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load data: $error';
        isLoading = false;
      });
    }
  }
}
