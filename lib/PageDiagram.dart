import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum Period { Yearly, Monthly, Daily }

class Utama extends StatefulWidget {
  const Utama({Key? key}) : super(key: key);

  @override
  _UtamaState createState() => _UtamaState();
}

class _UtamaState extends State<Utama> {
  // Data dummy untuk penjualan tahunan
  final List<Sales> yearlyData = [
    Sales(year: "2017", products: 16000000),
    Sales(year: "2018", products: 15000000),
    Sales(year: "2019", products: 10000000),
    Sales(year: "2020", products: 12000000),
    Sales(year: "2021", products: 15000000),
    Sales(year: "2022", products: 16000000),
    Sales(year: "2023", products: 18000000),
  ];

  // Data dummy untuk penjualan bulanan
  final List<Sales> monthlyData = [
    Sales(month: "Jan", products: 16000000),
    Sales(month: "Feb", products: 15000000),
    Sales(month: "Mar", products: 10000000),
    Sales(month: "Apr", products: 12000000),
    Sales(month: "May", products: 15000000),
    Sales(month: "Jun", products: 16000000),
    Sales(month: "Jul", products: 18000000),
    Sales(month: "Aug", products: 17000000),
    Sales(month: "Sep", products: 14000000),
    Sales(month: "Oct", products: 16000000),
    Sales(month: "Nov", products: 18000000),
    Sales(month: "Dec", products: 20000000),
  ];

  // Data dummy untuk penjualan harian
  final List<Sales> dailyData = [
    Sales(day: "1", products: 100000),
    Sales(day: "2", products: 150000),
    Sales(day: "3", products: 200000),
    Sales(day: "4", products: 250000),
    Sales(day: "5", products: 300000),
    Sales(day: "6", products: 350000),
    Sales(day: "7", products: 400000),
    // Tambahkan data harian lainnya di sini
  ];

  Period _selectedPeriod = Period.Yearly;

  @override
  Widget build(BuildContext context) {
    // Menyiapkan data sesuai dengan periode yang dipilih
    List<Sales> selectedData = [];
    switch (_selectedPeriod) {
      case Period.Yearly:
        selectedData = yearlyData;
        break;
      case Period.Monthly:
        selectedData = monthlyData;
        break;
      case Period.Daily:
        selectedData = dailyData;
        break;
    }

    // Setting diagram
    List<charts.Series<Sales, String>> series = [
      charts.Series(
        id: "Products",
        data: selectedData,
        domainFn: (Sales series, _) {
          if (_selectedPeriod == Period.Yearly) {
            return series.year!;
          } else if (_selectedPeriod == Period.Monthly) {
            return series.month!;
          } else {
            return series.day!;
          }
        },
        measureFn: (Sales series, _) => series.products,
      )
    ];

    return SafeArea(
      child: Center(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Statistik Penjualan Produk",
                  ),
                  DropdownButton<Period>(
                    value: _selectedPeriod,
                    onChanged: (Period? newValue) {
                      setState(() {
                        _selectedPeriod = newValue!;
                      });
                    },
                    items: Period.values.map((Period period) {
                      return DropdownMenuItem<Period>(
                        value: period,
                        child: Text(period.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    // Menampilkan chart
                    // Tambahkan vertical: false jika ingin membuat chart horizontal
                    child: charts.BarChart(series, animate: true),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Membuat model
class Sales {
  final String? year;
  final String? month;
  final String? day;
  final int products;

  // Constructor untuk data tahunan
  Sales({this.year, this.month, this.day, required this.products});
}
