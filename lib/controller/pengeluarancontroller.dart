import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/model/pengeluaranmodel.dart';

class PengeluaranController {
  final pengeluaranCollection =
      FirebaseFirestore.instance.collection('pengeluaran');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addPengeluaran(PengeluaranModel pmodel) async {
    final pengeluaran = pmodel.toMap();

    final DocumentReference docRef =
        await pengeluaranCollection.add(pengeluaran);

    final String docID = docRef.id;

    final PengeluaranModel pengeluaranModel = PengeluaranModel(
      pengeluaranId: docID,
      harga: pmodel.harga,
      keterangan: pmodel.keterangan,
      tanggal: pmodel.tanggal,
    );

    await docRef.update(pengeluaranModel.toMap());
  }

  Future<void> updatePengeluaran(PengeluaranModel pmodel) async {
    final PengeluaranModel pengeluaranModel = PengeluaranModel(
      pengeluaranId: pmodel.pengeluaranId,
      keterangan: pmodel.keterangan,
      harga: pmodel.harga,
      tanggal: pmodel.tanggal,
    );

    await pengeluaranCollection
        .doc(pmodel.pengeluaranId)
        .update(pengeluaranModel.toMap());
  }

  Future<void> removePengeluaran(String pengeluaranId) async {
    await pengeluaranCollection.doc(pengeluaranId).delete();
  }

  Future getPengeluaran() async {
    final pengeluaran = await pengeluaranCollection.get();
    streamController.sink.add(pengeluaran.docs);
    return pengeluaran.docs;
  }

  Future<List<DocumentSnapshot>> getPengeluaranSortedByDate() async {
    final pengeluaran = await pengeluaranCollection.get();
    List<DocumentSnapshot> pengeluaranDocs = pengeluaran.docs;

    pengeluaranDocs.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['tanggal']);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['tanggal']);
      return dateB.compareTo(dateA); // Sort in descending order (latest first)
    });

    streamController.sink.add(pengeluaranDocs);
    return pengeluaranDocs;
  }

  Future<String> getTotalPengeluaran() async {
    try {
      final pengeluaran = await pengeluaranCollection
          //.where('deletedAt', isEqualTo: 0)
          .get();
      double total = 0;
      pengeluaran.docs.forEach((doc) {
        PengeluaranModel pengeluaranModel =
            PengeluaranModel.fromMap(doc.data() as Map<String, dynamic>);
        double harga = double.tryParse(pengeluaranModel.harga) ?? 0;
        total += harga;
      });
      return total.toStringAsFixed(3);
    } catch (e) {
      print('Error while getting total pengeluaran: $e');
      return '0';
    }
  }

  Future<List<PengeluaranModel>> getPengeluaranByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pengeluaran = await pengeluaranCollection
        // .where('deletedAt', isEqualTo: 0)
        .get();
    final filteredPengeluaran = <PengeluaranModel>[];

    pengeluaran.docs.forEach((doc) {
      final pengeluaranModel =
          PengeluaranModel.fromMap(doc.data() as Map<String, dynamic>);
      final dateFormat = DateFormat("dd-MM-yyyy");
      final parsedDate = dateFormat.parse(pengeluaranModel.tanggal);

      // Filter data berdasarkan tanggal
      if (parsedDate.isAfter(startDate) && parsedDate.isBefore(endDate)) {
        filteredPengeluaran.add(pengeluaranModel);
      } else if (parsedDate.isAtSameMomentAs(startDate) ||
          parsedDate.isAtSameMomentAs(endDate)) {
        filteredPengeluaran.add(pengeluaranModel);
      }
    });

    return filteredPengeluaran;
  }
}
