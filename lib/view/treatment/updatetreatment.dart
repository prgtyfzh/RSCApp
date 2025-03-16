import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/treatmentcontroller.dart';
import 'package:redlenshoescleaning/model/treatmentmodel.dart';

class UpdateTreatment extends StatefulWidget {
  const UpdateTreatment({
    Key? key,
    this.treatmentID,
    this.treatment,
    this.hargaTreatment,
  }) : super(key: key);

  final String? treatmentID;
  final String? treatment;
  final String? hargaTreatment;

  @override
  State<UpdateTreatment> createState() => _UpdateTreatmentState();
}

class _UpdateTreatmentState extends State<UpdateTreatment> {
  var treatmentController = TreatmentController();
  final _formkey = GlobalKey<FormState>();

  String? newtreatment;
  String? newhargaTreatment;

  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _hargaTreatmentController =
      TextEditingController();

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 241, 240),
          title: const Text('Konfirmasi Perubahan'),
          content: const Text('Yakin ingin mengubah Treatment?'),
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
                  _updateTreatment();
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

  void _updateTreatment() {
    final newTreatment = _treatmentController.text;
    final newHargaTreatment = _hargaTreatmentController.text;

    if (newTreatment != null && newHargaTreatment != null) {
      TreatmentModel tm = TreatmentModel(
        treatmentID: widget.treatmentID,
        treatment: newTreatment,
        hargaTreatment: newHargaTreatment,
      );
      treatmentController.updateTreatment(tm);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treatment Berubah'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _treatmentController.text = widget.treatment ?? '';
    _hargaTreatmentController.text = widget.hargaTreatment ?? '';
    newtreatment = widget.treatment;
    newhargaTreatment = widget.hargaTreatment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Edit Treatment',
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
                height: 380,
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
                              'Jenis Treatment',
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
                            controller: _treatmentController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jenis treatment tidak boleh kosong!';
                              } else if (value.length > 20) {
                                return 'Jenis Treatment maksimal 20 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Jenis Treatment harus berisi huruf alphabet saja.';
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
                              'Harga',
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
                            controller: _hargaTreatmentController,
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
                                  newhargaTreatment = formattedHarga;
                                });

                                _hargaTreatmentController.value =
                                    _hargaTreatmentController.value.copyWith(
                                  text: formattedHarga,
                                  selection: TextSelection.collapsed(
                                      offset: formattedHarga.length),
                                );
                              } else {
                                setState(() {
                                  newhargaTreatment = null;
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
