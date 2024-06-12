import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageMap extends StatefulWidget {
  const PageMap({Key? key}) : super(key: key);

  @override
  _PageMapState createState() => _PageMapState();
}

class _PageMapState extends State<PageMap> {
  final CollectionReference _barangMasukCollection =
      FirebaseFirestore.instance.collection('barang_masuk');

  List<Map<String, dynamic>> barangData = [];

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barang Keluar(Firebase)'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBarangList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showTambahBarangMasukDialog(context);
                },
                child: const Text('Tambah Barang Masuk'),
              ),
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
                  'Deskripsi: ${barang['deskripsi']}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  'Harga: ${barang['harga']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Jumlah: ${barang['jumlah']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditBarangMasukDialog(context, barang);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmation(barang['key'], barang['nama']);
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showTambahBarangMasukDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Barang Masuk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _jumlahController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _tambahBarangMasuk(
                  _namaController.text.trim(),
                  _deskripsiController.text.trim(),
                  double.parse(_hargaController.text.trim()),
                  int.parse(_jumlahController.text.trim()),
                );
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBarangMasukDialog(
      BuildContext context, Map<String, dynamic> barang) {
    _namaController.text = barang['nama'];
    _deskripsiController.text = barang['deskripsi'];
    _hargaController.text = barang['harga'].toString();
    _jumlahController.text = barang['jumlah'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Barang Masuk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _jumlahController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _editBarangMasuk(
                  barang['key'],
                  _namaController.text.trim(),
                  _deskripsiController.text.trim(),
                  double.parse(_hargaController.text.trim()),
                  int.parse(_jumlahController.text.trim()),
                );
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(String docId, String namaBarang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Barang Masuk'),
          content: Text(
              'Apakah Anda yakin ingin menghapus barang masuk $namaBarang?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup alert
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _barangMasukCollection.doc(docId).delete();
                  print('Data deleted successfully');
                  getData();
                  Navigator.of(context).pop(); // Tutup alert
                } catch (error) {
                  print('Failed to delete data: $error');
                }
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _tambahBarangMasuk(
      String nama, String deskripsi, double harga, int jumlah) async {
    try {
      await _barangMasukCollection.add({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'jumlah': jumlah,
      });
      print('Data added successfully');
      getData();
      _namaController.clear();
      _deskripsiController.clear();
      _hargaController.clear();
      _jumlahController.clear();
    } catch (error) {
      print('Failed to add data: $error');
    }
  }

  void _editBarangMasuk(String docId, String nama, String deskripsi,
      double harga, int jumlah) async {
    try {
      await _barangMasukCollection.doc(docId).update({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'jumlah': jumlah,
      });
      print('Data updated successfully');
      getData();
      _namaController.clear();
      _deskripsiController.clear();
      _hargaController.clear();
      _jumlahController.clear();
    } catch (error) {
      print('Failed to update data: $error');
    }
  }

  void getData() {
    _barangMasukCollection.get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> newData = [];
        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (document.exists) {
            newData.add({
              'key': document.id,
              'nama': data['nama'],
              'deskripsi': data['deskripsi'],
              'harga': data['harga'],
              'jumlah': data['jumlah'],
            });
          }
        }
        setState(() {
          barangData = newData;
        });
      }
    }).catchError((error) {
      print("Failed to fetch data: $error");
    });
  }
}
