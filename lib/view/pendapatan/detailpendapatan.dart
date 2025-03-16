import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPendapatan extends StatelessWidget {
  const DetailPendapatan({
    Key? key,
    required this.tglMasuk,
    required this.tglKeluar,
    required this.namaCust,
    required this.telpCust,
    required this.alamatCust,
    required this.sepatuCust,
    required this.treatment,
    required this.hargaTreatment,
  }) : super(key: key);

  final String tglMasuk;
  final String tglKeluar;
  final String namaCust;
  final String telpCust;
  final String alamatCust;
  final String sepatuCust;
  final String treatment;
  final String hargaTreatment;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Detail Pendapatan',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/LoginPage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailItem('Tanggal Masuk', tglMasuk),
              buildDivider(),
              buildDetailItem('Tanggal Keluar', tglKeluar),
              buildDivider(),
              buildDetailItem('Nama Customer', namaCust),
              buildDivider(),
              buildDetailItem('No. Telepon', telpCust),
              buildDivider(),
              buildDetailItem('Alamat', alamatCust),
              buildDivider(),
              buildDetailItem('Sepatu', sepatuCust),
              buildDivider(),
              buildDetailItem('Jenis Treatment', treatment),
              buildDivider(),
              buildDetailItem('Harga', 'Rp$hargaTreatment'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: Colors.black,
      height: 16,
      thickness: 1,
    );
  }
}
