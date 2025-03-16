import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
import 'package:redlenshoescleaning/model/pendapatanmodel.dart';
import 'package:redlenshoescleaning/view/pendapatan/pendapatan.dart';

class UpdatePendapatan extends StatefulWidget {
  const UpdatePendapatan({
    Key? key,
    this.pendapatanID,
    this.tglMasuk,
    this.tglKeluar,
    this.namaCust,
    this.telpCust,
    this.alamatCust,
    this.sepatuCust,
    this.hargaTreatment,
    this.treatment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : super(key: key);

  final String? pendapatanID;
  final String? tglMasuk;
  final String? tglKeluar;
  final String? namaCust;
  final String? telpCust;
  final String? alamatCust;
  final String? sepatuCust;
  final String? hargaTreatment;
  final String? treatment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  @override
  State<UpdatePendapatan> createState() => _UpdatePendapatanState();
}

class _UpdatePendapatanState extends State<UpdatePendapatan> {
  var pendapatanController = PendapatanController();

  final _formkey = GlobalKey<FormState>();

  String? newtglMasuk;
  String? newtglKeluar;
  String? newnamaCust;
  String? newtelpCust;
  String? newalamatCust;
  String? newsepatuCust;
  String? newhargaTreatment;
  String? newtreatment;

  final TextEditingController _tglMasukController = TextEditingController();
  final TextEditingController _tglKeluarController = TextEditingController();

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Yakin ingin mengubah pendapatan?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ubah'),
              onPressed: () {
                Navigator.of(context).pop();
                _updatePendapatan();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePendapatan() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      PendapatanModel penm = PendapatanModel(
        pendapatanID: widget.pendapatanID,
        tglMasuk: newtglMasuk!.toString(),
        tglKeluar: newtglKeluar!.toString(),
        namaCust: newnamaCust!.toString(),
        telpCust: newtelpCust!.toString(),
        alamatCust: newalamatCust!.toString(),
        sepatuCust: newsepatuCust!.toString(),
        hargaTreatment: newhargaTreatment!.toString(),
        treatment: newtreatment!.toString(),
      );
      pendapatanController.updatePendapatan(penm);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendapatan Berubah'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Pendapatan(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tglMasukController.text = widget.tglMasuk!;
    _tglKeluarController.text = widget.tglKeluar!;
    newtreatment = widget.treatment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Edit Pendapatan',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/LoginPage.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Container(
                  width: 350,
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
                                'Tanggal Masuk',
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
                              controller: _tglMasukController,
                              decoration: InputDecoration(
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
                                      newtglMasuk = DateFormat('dd-MM-yyyy')
                                          .format(tanggalm)
                                          .toString();

                                      setState(() {
                                        _tglMasukController.text = newtglMasuk!;
                                      });
                                    }
                                  },
                                ),
                              ),
                              onSaved: (value) {
                                newtglMasuk = value;
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
                                'Tanggal Keluar',
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
                              controller: _tglKeluarController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? tanggalk = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2025),
                                    );

                                    if (tanggalk != null) {
                                      newtglKeluar = DateFormat('dd-MM-yyyy')
                                          .format(tanggalk)
                                          .toString();

                                      setState(() {
                                        _tglKeluarController.text =
                                            newtglKeluar!;
                                      });
                                    }
                                  },
                                ),
                              ),
                              onSaved: (value) {
                                newtglKeluar = value;
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
                                'Nama Customer',
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
                                  return 'Nama customer tidak boleh kosong!';
                                } else if (value.length > 30) {
                                  return 'Nama Customer maksimal 30 karakter!';
                                } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                    .hasMatch(value)) {
                                  return 'Nama Customer harus berisi huruf alphabet saja.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newnamaCust = value;
                              },
                              initialValue: widget.namaCust,
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
                                'No. Telepon',
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
                              keyboardType: TextInputType
                                  .number, // Set the keyboard type to number
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly // Allow only digits
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'No. Telepon tidak boleh kosong!';
                                } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                                  return 'No. Telepon harus berisi angka saja.';
                                } else if (value.length < 10 ||
                                    value.length > 13) {
                                  return 'No. Telepon harus terdiri dari 10 hingga 13 karakter!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newtelpCust = value;
                              },
                              initialValue: widget.telpCust,
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
                                'Alamat',
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
                                  return 'Alamat tidak boleh kosong!';
                                } else if (value.length > 50) {
                                  return 'Alamat maksimal 50 karakter!';
                                } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                    .hasMatch(value)) {
                                  return 'Alamat hanya boleh berisi huruf alfabet dan angka.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newalamatCust = value;
                              },
                              initialValue: widget.alamatCust,
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
                                'Sepatu',
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
                                  return 'Sepatu tidak boleh kosong!';
                                } else if (value.length > 30) {
                                  return 'Sepatu maksimal 30 karakter!';
                                } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                    .hasMatch(value)) {
                                  return 'Sepatu hanya boleh berisi huruf alfabet dan angka.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newsepatuCust = value;
                              },
                              initialValue: widget.sepatuCust,
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
                                'Jenis Treatment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('treatments')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                List<DropdownMenuItem<String>> dropdownItems =
                                    [];
                                final items = snapshot.data!.docs;
                                for (var item in items) {
                                  // Assuming the 'jenistreatment' field exists in each document
                                  String itemName = item['treatment'];
                                  dropdownItems.add(
                                    DropdownMenuItem(
                                      value: itemName,
                                      child: Text(itemName),
                                    ),
                                  );
                                }

                                return Container(
                                  width: 300,
                                  child: DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(10.0),
                                    icon: const Icon(
                                        Icons.arrow_drop_down_circle_rounded),
                                    value: newtreatment,
                                    items: dropdownItems,
                                    onChanged: (item) async {
                                      setState(() {
                                        newtreatment = item;
                                      });
                                      newhargaTreatment = await getHargaByItem(
                                          item!); // Fetch the harga for the selected item
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Pilih Jenis Treatment',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Jenis treatment tidak boleh kosong!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      newtreatment = value;
                                    },
                                  ),
                                );
                              }
                            },
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
                            child: FutureBuilder<String?>(
                              future: newtreatment != null
                                  ? getHargaByItem(newtreatment!)
                                  : null,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  String harga = snapshot.data ?? '';
                                  return TextFormField(
                                    initialValue: harga,
                                    decoration: InputDecoration(
                                      hintText: 'Harga',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onSaved: (value) {
                                      newhargaTreatment = value;
                                    },
                                    readOnly: true,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                PendapatanModel penmodel = PendapatanModel(
                                  pendapatanID: widget.pendapatanID,
                                  namaCust: newnamaCust!.toString(),
                                  telpCust: newtelpCust!.toString(),
                                  alamatCust: newalamatCust!.toString(),
                                  sepatuCust: newsepatuCust!.toString(),
                                  treatment: newtreatment!.toString(),
                                  tglMasuk: newtglMasuk!.toString(),
                                  tglKeluar: newtglKeluar!.toString(),
                                  hargaTreatment: newhargaTreatment!.toString(),
                                );
                                pendapatanController.updatePendapatan(penmodel);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pendapatan Berubah'),
                                  ),
                                );
                                Navigator.pop(context, true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0C8346),
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
      ),
    );
  }
}

Future<String?> getHargaByItem(String selectedItem) async {
  try {
    // Perform a query to get the harga from Firestore based on the selected item
    var snapshot = await FirebaseFirestore.instance
        .collection('treatments')
        .where('treatment', isEqualTo: selectedItem)
        .limit(1)
        .get();

    // Assuming the 'harga' field exists in each document
    if (snapshot.docs.isNotEmpty) {
      var document = snapshot.docs.first;
      if (document.data().containsKey('hargaTreatment')) {
        return document.data()['hargaTreatment'].toString();
      }
    }
  } catch (e) {
    print('Error fetching hargaTreatment: $e');
  }

  return null;
}
