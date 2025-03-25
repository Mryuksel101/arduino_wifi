import 'package:arduino_wifi/common/models/arrow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArrowService {
  final CollectionReference arrowsCollection =
      FirebaseFirestore.instance.collection('arrows');

  // Add a new arrow
  Future<String> addArrow(Arrow arrow) async {
    DocumentReference docRef = await arrowsCollection.add(arrow.toFirestore());
    return docRef.id;
  }

  // Get all arrows
  Stream<List<Arrow>> getArrows() {
    return arrowsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Arrow.fromFirestore(doc)).toList());
  }

  // Get a specific arrow
  Future<Arrow?> getArrow(String id) async {
    DocumentSnapshot doc = await arrowsCollection.doc(id).get();
    if (doc.exists) {
      return Arrow.fromFirestore(doc);
    }
    return null;
  }

  // Update an arrow
  Future<void> updateArrow(Arrow arrow) {
    return arrowsCollection.doc(arrow.id).update(arrow.toFirestore());
  }

  // Delete an arrow
  Future<void> deleteArrow(String id) {
    return arrowsCollection.doc(id).delete();
  }
}
