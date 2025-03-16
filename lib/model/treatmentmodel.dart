// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TreatmentModel {
  String? treatmentID;
  final String treatment;
  final String hargaTreatment;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // DateTime? deletedAt;
  TreatmentModel({
    this.treatmentID,
    required this.treatment,
    required this.hargaTreatment,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
  });

  TreatmentModel copyWith({
    String? treatmentID,
    String? treatment,
    String? hargaTreatment,
    // DateTime? createdAt,
    // DateTime? updatedAt,
    // DateTime? deletedAt,
  }) {
    return TreatmentModel(
      treatmentID: treatmentID ?? this.treatmentID,
      treatment: treatment ?? this.treatment,
      hargaTreatment: hargaTreatment ?? this.hargaTreatment,
      // createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
      // deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'treatmentID': treatmentID,
      'treatment': treatment,
      'hargaTreatment': hargaTreatment,
      // 'createdAt': createdAt?.millisecondsSinceEpoch,
      // 'updatedAt': updatedAt?.millisecondsSinceEpoch,
      // 'deletedAt': deletedAt?.millisecondsSinceEpoch,
    };
  }

  factory TreatmentModel.fromMap(Map<String, dynamic> map) {
    return TreatmentModel(
      treatmentID:
          map['treatmentID'] != null ? map['treatmentID'] as String : null,
      treatment: map['treatment'] as String,
      hargaTreatment: map['hargaTreatment'] as String,
      // createdAt: map['createdAt'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
      //     : null,
      // updatedAt: map['updatedAt'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
      //     : null,
      // deletedAt: map['deletedAt'] != null
      //     ? DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int)
      //     : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TreatmentModel.fromJson(String source) =>
      TreatmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TreatmentModel(treatmentID: $treatmentID, treatment: $treatment, hargaTreatment: $hargaTreatment)';
  }

  //   @override
  // String toString() {
  //   return 'TreatmentModel(treatmentID: $treatmentID, treatment: $treatment, hargaTreatment: $hargaTreatment, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  // }

  @override
  bool operator ==(covariant TreatmentModel other) {
    if (identical(this, other)) return true;

    return other.treatmentID == treatmentID &&
        other.treatment == treatment &&
        other.hargaTreatment == hargaTreatment
        // other.createdAt == createdAt &&
        // other.updatedAt == updatedAt &&
        // other.deletedAt == deletedAt
        ;
  }

  @override
  int get hashCode {
    return treatmentID.hashCode ^
        treatment.hashCode ^
        hargaTreatment.hashCode 
        // createdAt.hashCode ^
        // updatedAt.hashCode ^
        // deletedAt.hashCode
        ;
  }
}
