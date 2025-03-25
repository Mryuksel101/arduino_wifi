import 'package:cloud_firestore/cloud_firestore.dart';

class Arrow {
  String? id; // Firestore document ID
  String? code; // Unique identifier for the arrow
  double? weight; // Weight in grams
  double? balancePoint; // Center of gravity as percentage
  double? leftSpine; // First spine measurement
  double? rightSpine; // Second spine measurement
  Timestamp? createdAt; // Firestore timestamp
  String? notes;

  Arrow({
    this.id,
    required this.code,
    required this.weight,
    required this.balancePoint,
    required this.leftSpine,
    required this.rightSpine,
    required this.createdAt,
    this.notes,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'weight': weight,
      'balancePoint': balancePoint,
      'leftSpine': leftSpine,
      'rightSpine': rightSpine,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'notes': notes,
    };
  }

  // Create from Firestore document
  factory Arrow.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Arrow(
      id: doc.id, // Save the Firestore document ID
      code: data['code'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
      balancePoint: (data['balancePoint'] ?? 0).toDouble(),
      leftSpine: (data['leftSpine'] ?? 0).toDouble(),
      rightSpine: (data['rightSpine'] ?? 0).toDouble(),
      createdAt: data['createdAt'] as Timestamp,
      notes: data['notes'],
    );
  }

  // Copy with new values
  Arrow copyWith({
    String? id,
    String? code,
    double? weight,
    double? balancePoint,
    double? leftSpine,
    double? rightSpine,
    String? notes,
  }) {
    return Arrow(
      id: id ?? this.id,
      code: code ?? this.code,
      weight: weight ?? this.weight,
      balancePoint: balancePoint ?? this.balancePoint,
      leftSpine: leftSpine ?? this.leftSpine,
      rightSpine: rightSpine ?? this.rightSpine,
      createdAt: createdAt,
      notes: notes ?? this.notes,
    );
  }

  // arrow emty
  static Arrow empty() {
    return Arrow(
      code: '',
      weight: 0,
      balancePoint: 0,
      leftSpine: 0,
      rightSpine: 0,
      createdAt: null,
      notes: '',
    );
  }
}
