import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// High-level Firebase helper for the app.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  // --- Authentication ---
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- Exercises ---
  Future<List<Map<String, dynamic>>> getExercises({
    String? muscle,
    String? difficulty,
    String? category,
  }) async {
    Query query = _fs.collection('exercises');
    if (muscle != null) query = query.where('targetMuscle', isEqualTo: muscle);
    if (difficulty != null) {
      query = query.where('difficulty', isEqualTo: difficulty);
    }
    if (category != null) query = query.where('category', isEqualTo: category);
    // Firestore requires indexes for some compound queries; handle errors in caller
    query = query.orderBy('targetMuscle').orderBy('difficulty');

    final snap = await query.get();
    return snap.docs
        .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
        .toList();
  }

  // --- Assessment ---
  Future<DocumentReference> submitAssessment({
    required List<String> bodyParts,
    required String painType,
    required int severity,
    required String duration,
    List<String>? triggers,
    List<String>? limitations,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw FirebaseAuthException(code: 'NO_USER', message: 'Not signed in');
    }

    Query q = _fs.collection('exercises');
    if (bodyParts.isNotEmpty) {
      // Firestore supports whereIn up to 10 elements
      q = q.where(
        'targetMuscle',
        whereIn: bodyParts.length <= 10 ? bodyParts : bodyParts.sublist(0, 10),
      );
    }

    if (severity >= 8) {
      q = q.where('difficulty', isEqualTo: 'easy');
    } else if (severity >= 5) {
      q = q.where('difficulty', whereIn: ['easy', 'medium']);
    }

    final exSnap = await q.limit(10).get();
    final recommended = exSnap.docs
        .map((d) => _fs.collection('exercises').doc(d.id))
        .toList();

    final ref = await _fs
        .collection('users')
        .doc(uid)
        .collection('assessments')
        .add({
          'bodyParts': bodyParts,
          'painType': painType,
          'severity': severity,
          'duration': duration,
          'triggers': triggers ?? [],
          'limitations': limitations ?? [],
          'recommendedExercises': recommended,
          'createdAt': FieldValue.serverTimestamp(),
        });

    return ref;
  }

  Future<List<Map<String, dynamic>>> getAssessmentHistory({
    int limit = 20,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final snap = await _fs
        .collection('users')
        .doc(uid)
        .collection('assessments')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      final recs = (data['recommendedExercises'] as List<dynamic>?)
          ?.map((r) {
            if (r is DocumentReference) return r.id;
            if (r is String) return r;
            return null;
          })
          .where((e) => e != null)
          .cast<String>()
          .toList();
      return {'id': d.id, ...data, 'recommendedExercises': recs};
    }).toList();
  }
}
