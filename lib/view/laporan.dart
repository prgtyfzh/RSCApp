import 'package:flutter/material.dart';
import 'package:redlenshoescleaning/controller/datalaporan.dart';
import 'package:redlenshoescleaning/view/pendapatan/pendapatan.dart';
import 'package:redlenshoescleaning/view/pengeluaran/pengeluaran.dart';
import 'package:redlenshoescleaning/view/treatment/treatment.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DataLaporan(),
    const Pendapatan(),
    const Pengeluaran(),
    const Treatment(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
        child: SizedBox(
          height: 89,
          child: BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color(0xFF0C8346),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_up_sharp),
                label: 'Pendapatan',
                backgroundColor: Color(0xFF0C8346),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.trending_down_sharp),
                label: 'Pengeluaran',
                backgroundColor: Color(0xFF0C8346),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_sharp),
                label: 'Treatment',
                backgroundColor: Color(0xFF0C8346),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
