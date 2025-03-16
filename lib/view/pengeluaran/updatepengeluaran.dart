import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/pengeluarancontroller.dart';
import 'package:redlenshoescleaning/model/pengeluaranmodel.dart';

class UpdatePengeluaran extends StatefulWidget {
  const UpdatePengeluaran({
    Key? key,
    this.pengeluaranId,
    this.keterangan,
    this.harga,
    this.tanggal,
  }) : super(key: key);

  final String? pengeluaranId;
  final String? keterangan;
  final String? harga;
  final String? tanggal;

  @override
  State<UpdatePengeluaran> createState() => _UpdatePengeluaranState();
}

class _UpdatePengeluaranState extends State<UpdatePengeluaran> {
  var pengeluaranController = PengeluaranController();
  final _formkey = GlobalKey<FormState>();

  String? newketerangan;
  String? newharga;
  String? newtanggal;

  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Perubahan'),
          content: const Text('Yakin ingin mengubah Pengeluaran?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Ubah',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  _updatePengeluaran();
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePengeluaran() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      PengeluaranModel pm = PengeluaranModel(
        pengeluaranId: widget.pengeluaranId,
        keterangan: newketerangan!.toString(),
        harga: newharga!.toString(),
        tanggal: newtanggal!.toString(),
      );

      pengeluaranController.updatePengeluaran(pm);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengeluaran Berubah'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tanggalController.text = widget.tanggal ?? '';
    _keteranganController.text = widget.keterangan ?? '';
    _hargaController.text = widget.harga ?? '';
    newtanggal = widget.tanggal;
    newketerangan = widget.keterangan;
    newharga = widget.harga;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Edit Pengeluaran',
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
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tanggal',
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime? tanggal = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (tanggal != null) {
                                    newtanggal = DateFormat('dd-MM-yyyy')
                                        .format(tanggal)
                                        .toString();

                                    setState(() {
                                      _tanggalController.text = newtanggal!;
                                    });
                                  }
                                },
                              ),
                            ),
                            onSaved: (value) {
                              newtanggal = value;
                            },
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama barang tidak boleh kosong!';
                              } else if (value.length > 50) {
                                return 'Nama Barang maksimal 50 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Nama Barang harus berisi huruf alphabet saja.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              newketerangan = value;
                            },
                            initialValue: widget.keterangan,
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
                            controller: _hargaController,
                            decoration: InputDecoration(
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
                                return 'Harga barang tidak boleh kosong!';
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
                                  newharga = formattedHarga;
                                });

                                _hargaController.value =
                                    _hargaController.value.copyWith(
                                  text: formattedHarga,
                                  selection: TextSelection.collapsed(
                                      offset: formattedHarga.length),
                                );
                              } else {
                                setState(() {
                                  newharga = null;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog(context);
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
