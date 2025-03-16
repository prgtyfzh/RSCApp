import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/treatmentcontroller.dart';
import 'package:redlenshoescleaning/model/treatmentmodel.dart';

class CreateTreatment extends StatefulWidget {
  const CreateTreatment({super.key});

  @override
  State<CreateTreatment> createState() => _CreateTreatmentState();
}

class _CreateTreatmentState extends State<CreateTreatment> {
  var treatmentController = TreatmentController();
  final _formkey = GlobalKey<FormState>();

  String? treatment;
  String? hargaTreatment;

  TextEditingController hargaController =
      TextEditingController(); // Add this line

  @override
  void dispose() {
    hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Tambahkan Treatment',
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
                        const SizedBox(height: 20),
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
                            decoration: InputDecoration(
                              hintText: 'Masukkan jenis treatment',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Jenis Treatment tidak boleh kosong!';
                              } else if (value.length > 20) {
                                return 'Jenis Treatment maksimal 20 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Jenis Treatment harus berisi huruf alphabet saja.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              treatment = value;
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
                              'Harga', // Teks di atas TextFormField
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
                            controller: hargaController, // Add this line
                            decoration: InputDecoration(
                              hintText: 'Masukkan harga',
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
                                  hargaTreatment = formattedHarga;
                                });

                                hargaController.value =
                                    hargaController.value.copyWith(
                                  text: formattedHarga,
                                  selection: TextSelection.collapsed(
                                      offset: formattedHarga.length),
                                );
                              } else {
                                setState(() {
                                  hargaTreatment = null;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              TreatmentModel tm = TreatmentModel(
                                treatment: treatment!,
                                hargaTreatment: hargaTreatment!,
                              );
                              treatmentController.addTreatment(tm);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Treatment Ditambahkan')));
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
