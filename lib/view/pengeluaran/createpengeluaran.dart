import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/pengeluarancontroller.dart';
import 'package:redlenshoescleaning/model/pengeluaranmodel.dart';

class CreatePengeluaran extends StatefulWidget {
  const CreatePengeluaran({Key? key}) : super(key: key);

  @override
  State<CreatePengeluaran> createState() => _CreatePengeluaranState();
}

class _CreatePengeluaranState extends State<CreatePengeluaran> {
  final pengeluaranController = PengeluaranController();
  final _formkey = GlobalKey<FormState>();

  String? keterangan;
  String? harga;
  String? tanggal;

  TextEditingController hargaController =
      TextEditingController(); // Add this line

  @override
  void dispose() {
    hargaController.dispose();
    super.dispose();
  }

  final TextEditingController _tanggalController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Tambahkan Pengeluaran',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: 450,
          height: 1000,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/LoginPage.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              // Wrap the Container with Center
              child: Container(
                width: 350,
                height: 490,
                decoration: BoxDecoration(
                  color: const Color(0xff8fd5a6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formkey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tanggal Pengeluaran', // Teks di atas TextFormField
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            controller: _tanggalController,
                            decoration: InputDecoration(
                              hintText: 'Pilih tanggal pengeluaran',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime? tanggalm = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2025),
                                  );
                                  if (tanggalm != null) {
                                    tanggal = DateFormat('dd-MM-yyyy')
                                        .format(tanggalm);

                                    setState(() {
                                      _tanggalController.text =
                                          tanggal.toString();
                                    });
                                  }
                                },
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal tidak boleh kosong!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Nama Barang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama barang',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama Barang tidak boleh kosong!';
                              } else if (value.length > 50) {
                                return 'Nama Barang maksimal 50 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Nama Barang harus berisi huruf alphabet saja.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              keterangan = value;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Harga Barang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            controller: hargaController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan harga barang',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType
                                .number, // Set the keyboard type to number
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly // Allow only digits
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Harga tidak boleh kosong!';
                              } else if (!RegExp(r'^\d{1,3}(.\d{3})*(\.\d+)?$')
                                  .hasMatch(value)) {
                                return 'Harga harus berisi angka saja.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final numberFormat =
                                  NumberFormat("#,##0", "id_ID");
                              final newValue = value.replaceAll(",", "");

                              if (newValue.isNotEmpty) {
                                final formattedHarga =
                                    numberFormat.format(int.parse(newValue));

                                setState(() {
                                  harga = formattedHarga;
                                });

                                hargaController.value =
                                    hargaController.value.copyWith(
                                  text: formattedHarga,
                                  selection: TextSelection.collapsed(
                                      offset: formattedHarga.length),
                                );
                              } else {
                                setState(() {
                                  harga = null;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              PengeluaranModel pm = PengeluaranModel(
                                tanggal: tanggal!,
                                keterangan: keterangan!,
                                harga: harga!,
                              );
                              pengeluaranController.addPengeluaran(pm);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pengeluaran Ditambahkan'),
                                ),
                              );
                              Navigator.pop(context, true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff329f5b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
