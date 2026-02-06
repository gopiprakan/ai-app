import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveScanResult(CropDetectionResult result) async {
    await _db.collection('scans').add(result.toMap());
  }

  Stream<List<CropDetectionResult>> getScanHistory(String userId) {
    return _db
        .collection('scans')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CropDetectionResult.fromMap(doc.data(), doc.id))
            .toList());
  }
}
