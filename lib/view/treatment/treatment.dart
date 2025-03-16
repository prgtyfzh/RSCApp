import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/treatmentcontroller.dart';
import 'package:redlenshoescleaning/view/treatment/createtreatment.dart';
import 'package:redlenshoescleaning/view/treatment/updatetreatment.dart';

class Treatment extends StatefulWidget {
  const Treatment({Key? key});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  var tc = TreatmentController();
  String keyword = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    tc.getTreatment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: isSearching
            ? Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Cari treatment...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onChanged: (newKeyword) {
                    setState(() {
                      keyword = newKeyword;
                    });
                  },
                ),
              )
            : Text(
                'Daftar Treatment',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/LoginPage.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: tc.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<DocumentSnapshot> data = snapshot.data!;

                    // Implementasi logika pencarian
                    List<DocumentSnapshot> filteredDocuments =
                        data.where((document) {
                      Map<String, dynamic> treatment =
                          document.data() as Map<String, dynamic>;
                      String searchField = treatment['treatment'] +
                          treatment['hargatreatment'].toString();
                      return searchField
                          .toLowerCase()
                          .contains(keyword.toLowerCase());
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 20.0,
                          ),
                          child: Card(
                            color: const Color(0xff8fd5a6),
                            elevation: 4,
                            child: ListTile(
                              title:
                                  Text(filteredDocuments[index]['treatment']),
                              subtitle: Text(
                                  'Rp${filteredDocuments[index]['hargaTreatment']}'),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem(
                                      value: 'update',
                                      child: Text('Ubah'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Hapus'),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 'update') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTreatment(
                                          treatmentID: filteredDocuments[index]
                                              ['treatmentID'],
                                          treatment: filteredDocuments[index]
                                              ['treatment'],
                                          hargaTreatment:
                                              filteredDocuments[index]
                                                  ['hargaTreatment'],
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          tc.getTreatment();
                                        });
                                      }
                                    });
                                  } else if (value == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text(
                                              'Konfirmasi Penghapusan'),
                                          content: const Text(
                                              'Yakin ingin menghapus Treatment ini?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Batal',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Hapus',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                tc.removeTreatment(
                                                    filteredDocuments[index]
                                                            ['treatmentID']
                                                        .toString());
                                                setState(() {
                                                  tc.getTreatment();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTreatment(),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                tc.getTreatment();
              });
            }
          });
        },
        backgroundColor: const Color(0xff329f5b),
        child: const Icon(Icons.add),
      ),
    );
  }
}
