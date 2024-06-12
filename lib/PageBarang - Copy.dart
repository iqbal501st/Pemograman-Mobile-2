import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageBarang extends StatefulWidget {
  const PageBarang({Key? key}) : super(key: key);

  @override
  _PageBarangState createState() => _PageBarangState();
}

class _PageBarangState extends State<PageBarang> {
  final CollectionReference _barangCollection =
      FirebaseFirestore.instance.collection('barang');

  List<Map<String, dynamic>> barangData = [];

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  String selectedDescription = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Barang'),
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
                  _showTambahBarangDialog(context);
                },
                child: const Text('Tambah Barang'),
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
                    _showEditBarangDialog(context, barang);
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

  void _showTambahBarangDialog(BuildContext context) {
    List<String> descriptions = ['Makanan', 'Minuman']; // Description options

    String selectedDescription =
        descriptions[0]; // Default selected description
    int jumlahBarang = 1; // Default jumlah barang

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedDescription,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDescription = newValue!;
                  });
                },
                items: descriptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    jumlahBarang = int.tryParse(value) ?? 1;
                  });
                },
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
                addData(
                  _namaController.text.trim(),
                  selectedDescription,
                  double.parse(_hargaController.text.trim()),
                  jumlahBarang, // Pastikan jumlahBarang disertakan saat menambahkan data
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

  void _showEditBarangDialog(
      BuildContext context, Map<String, dynamic> barang) {
    List<String> descriptions = [
      'Makanan',
      'Minuman',
      'Peralatan'
    ]; // Description options

    String selectedDescription =
        barang['deskripsi']; // Initial selected description
    int jumlahBarang = barang['jumlah']; // Jumlah barang

    _namaController.text = barang['nama'];
    _hargaController.text = barang['harga'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Barang'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _namaController,
                    decoration: InputDecoration(labelText: 'Nama Barang'),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDescription,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDescription = newValue!;
                      });
                    },
                    items: descriptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _hargaController,
                    decoration: InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        jumlahBarang = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateData(
                      barang['key'],
                      _namaController.text.trim(),
                      selectedDescription,
                      double.parse(_hargaController.text.trim()),
                      jumlahBarang,
                    );
                    Navigator.pop(context);
                    getData(); // Memanggil kembali fungsi getData setelah mengedit data
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(String docId, String namaBarang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Barang'),
          content:
              Text('Apakah Anda yakin ingin menghapus barang $namaBarang?'),
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
                  await _barangCollection.doc(docId).delete();
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

  void addData(String nama, String deskripsi, double harga, int jumlah) async {
    try {
      await _barangCollection.add({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'jumlah': jumlah, // Set jumlah barang sesuai input pengguna
      });
      print('Data added successfully');
      getData();
      _namaController.clear();
      _hargaController.clear();
    } catch (error) {
      print('Failed to add data: $error');
    }
  }

  void updateData(String docId, String nama, String deskripsi, double harga,
      int jumlah) async {
    try {
      await _barangCollection.doc(docId).update({
        'nama': nama,
        'deskripsi': deskripsi,
        'harga': harga,
        'jumlah':
            jumlah, // Perbarui jumlah barang sesuai kebutuhan saat mengedit
      });
      print('Data updated successfully');
      getData();
      _namaController.clear();
      _hargaController.clear();
    } catch (error) {
      print('Failed to update data: $error');
    }
  }

  void getData() {
    _barangCollection.get().then((QuerySnapshot snapshot) {
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
              'jumlah':
                  data['jumlah'], // Menambahkan jumlah barang dari Firestore
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
