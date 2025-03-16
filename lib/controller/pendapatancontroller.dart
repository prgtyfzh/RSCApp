import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/model/pendapatanmodel.dart';

class PendapatanController {
  final pendapatanCollection =
      FirebaseFirestore.instance.collection('pendapatan');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
  List<DocumentSnapshot> currentData = [];

  Future<void> addPendapatan(PendapatanModel penmodel) async {
    final pendapatan = penmodel.toMap();

    final DocumentReference docRef = await pendapatanCollection.add(pendapatan);

    final String docID = docRef.id;

    final PendapatanModel pendapatanModel = PendapatanModel(
      pendapatanID: docID,
      namaCust: penmodel.namaCust,
      telpCust: penmodel.telpCust,
      alamatCust: penmodel.alamatCust,
      sepatuCust: penmodel.sepatuCust,
      treatment: penmodel.treatment,
      tglMasuk: penmodel.tglMasuk,
      tglKeluar: penmodel.tglKeluar,
      hargaTreatment: penmodel.hargaTreatment,
    );

    await docRef.update(pendapatanModel.toMap());
  }

  Future<void> updatePendapatan(PendapatanModel penmodel) async {
    final PendapatanModel pendapatanModel = PendapatanModel(
      namaCust: penmodel.namaCust,
      telpCust: penmodel.telpCust,
      alamatCust: penmodel.alamatCust,
      sepatuCust: penmodel.sepatuCust,
      treatment: penmodel.treatment,
      tglMasuk: penmodel.tglMasuk,
      tglKeluar: penmodel.tglKeluar,
      hargaTreatment: penmodel.hargaTreatment,
      pendapatanID: penmodel.pendapatanID,
    );

    await pendapatanCollection
        .doc(penmodel.pendapatanID)
        .update(pendapatanModel.toMap());
  }

  Future<void> removePendapatan(String pendapatanID) async {
    await pendapatanCollection.doc(pendapatanID).delete();
  }

  Future getPendapatan() async {
    final pendapatan = await pendapatanCollection.get();
    streamController.sink.add(pendapatan.docs);
    return pendapatan.docs;
  }

  Future<List<DocumentSnapshot>> getPendapatanSortedByDate() async {
    final pendapatan = await pendapatanCollection.get();
    List<DocumentSnapshot> pendapatanDocs = pendapatan.docs;

    pendapatanDocs.sort((a, b) {
      DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['tglMasuk']);
      DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['tglMasuk']);
      return dateB.compareTo(dateA); // Sort in descending order (latest first)
    });

    streamController.sink.add(pendapatanDocs);
    return pendapatanDocs;
  }

  Future<String> getTotalPendapatan() async {
    try {
      final pendapatan = await pendapatanCollection
          //.where('deletedAt', isEqualTo: 0)
          .get();
      double total = 0;
      pendapatan.docs.forEach((doc) {
        PendapatanModel pendapatanModel =
            PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
        double hargaTreatment =
            double.tryParse(pendapatanModel.hargaTreatment) ?? 0;
        total += hargaTreatment;
      });
      return total.toStringAsFixed(3);
    } catch (e) {
      print('Error while getting total pendapatan: $e');
      return '0';
    }
  }

  Future<List<PendapatanModel>> getPendapatanByDate(
      DateTime startDate, DateTime endDate) async {
    final pendapatan = await pendapatanCollection
        // .where('deletedAt', isEqualTo: 0)
        .get();
    final filteredPendapatan = <PendapatanModel>[];

    pendapatan.docs.forEach((doc) {
      final pendapatanModel =
          PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
      final tglMasuk = DateFormat("dd-MM-yyyy").parse(pendapatanModel.tglMasuk);

      if (tglMasuk.isAfter(startDate) && tglMasuk.isBefore(endDate)) {
        filteredPendapatan.add(pendapatanModel);
      } else if (tglMasuk.isAtSameMomentAs(startDate) ||
          tglMasuk.isAtSameMomentAs(endDate)) {
        filteredPendapatan.add(pendapatanModel);
      }
    });

    return filteredPendapatan;
  }

  void dispose() {
    streamController.close();
  }
}
