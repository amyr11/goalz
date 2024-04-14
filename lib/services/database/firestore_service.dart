import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_boilerplate/models/goal.dart';

const String goalCollection = 'goals';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User currentUser = FirebaseAuth.instance.currentUser!;

  late final CollectionReference<Map<String, dynamic>> _goalsColRef;

  FirestoreService() {
    _goalsColRef =
        _db.collection(goalCollection).doc(currentUser.uid).collection(goalCollection);
  }

  Stream<List<Goal>> streamGoals() {
    return _goalsColRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Goal.fromFirestore(doc)).toList());
  }

  Future<void> addGoal(Goal goal) async {
    await _goalsColRef.add(goal.toJson());
  }

  Future<void> updateGoal(Goal goal) async {
    await _goalsColRef.doc(goal.id).update(goal.toJson());
  }

  Future<void> deleteGoal(Goal goal) async {
    await _goalsColRef.doc(goal.id).delete();
  }

  Stream<Goal> streamGoal(String id) {
    return _goalsColRef
        .doc(id)
        .snapshots()
        .map((snapshot) => Goal.fromFirestore(snapshot));
  }
}