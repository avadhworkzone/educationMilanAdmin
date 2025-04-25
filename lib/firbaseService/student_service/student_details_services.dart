import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/enum_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';

class StudentService {
  static final _firestore = FirebaseFirestore.instance;
  static String get _familyCode => PreferenceManagerUtils.getFamilyCode();
  List<String> standardsList = [];
  List<String> villageList = [];

  ///=======================getStudentDataForAdmin===================///
  static Stream<List<StudentModel>> getStudentDataForAdmin({
    required String familyCode,
    required String standard,
    required bool isApproved,
    required StatusEnum statusEnum,
  }) async* {
    final usersRef = FirebaseFirestore.instance
        .collection('families')
        .doc(familyCode)
        .collection('users');

    final usersSnapshot = await usersRef.get();

    final List<StudentModel> allStudents = [];

    for (final userDoc in usersSnapshot.docs) {
      final resultsRef = usersRef.doc(userDoc.id).collection('results');

      final resultsSnapshot = await resultsRef
          .where('standard', isEqualTo: standard)
          .where('isApproved', isEqualTo: isApproved)
          .where('status', isEqualTo: statusEnum.name)
          .get();

      final students = resultsSnapshot.docs.map((doc) => StudentModel.fromJson(doc.data())).toList();
      allStudents.addAll(students);
    }

    // Sort the result
    allStudents.sort((a, b) => b.percentage!.compareTo(a.percentage!));
    yield allStudents;
  }

  Future<List<String>> getVillagesByFamily(String familyCode) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('village')
          .doc('villages')
          .get();

      if (doc.exists) {
        List<dynamic> data = doc['villages'] ?? [];
        villageList = data.map((e) => e.toString()).toList();
      }
      return villageList;
    } catch (e) {
      print('Error fetching villages: $e');
      return [];
    }
  }


  Future<List<String>> getStandardsByFamily(String familyCode) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('standerd')
          .doc('standerd')
          .get();

      if (doc.exists) {
        List<dynamic> data = doc['standerd'] ?? [];
        standardsList = data.map((e) => e.toString()).toList();
      }
      return standardsList;
    } catch (e) {
      print('Error fetching standards: $e');
      return [];
    }
  }


  ///=======================CREATE STUDENT===================///
  static Future<bool> createStudent(StudentModel studentDetail) async {
    try {
      final docRef = _firestore
          .collection('families')
          .doc(_familyCode) // assume _familyCode is already set
          .collection('users')
          .doc(studentDetail.userId) // ✅ MUST be passed before calling this
          .collection('results')
          .doc(); // 🔄 auto-ID

      // Assign required fields
      studentDetail.studentId = docRef.id;
      studentDetail.familyCode = _familyCode;
      studentDetail.createdDate = DateTime.now().toIso8601String();

      // ✅ These fields are REQUIRED for collectionGroup querying
      studentDetail.isApproved = false;
      studentDetail.status = StatusEnum.pending.name;

      await docRef.set(studentDetail.toJson());

      return true;
    } catch (e) {
      print('CREATE STUDENT ERROR: $e');
      return false;
    }
  }


  ///=======================GET FINAL DATA BY STANDARD===================///
  static Future<List<StudentModel>> getFinalStudentDataFuture({required String standard}) {
    return _firestore
        .collectionGroup('results')
        .where('familyCode', isEqualTo: _familyCode)
        .where('standard', isEqualTo: standard)
        .where('isApproved', isEqualTo: true)
        .where('status', isEqualTo: StatusEnum.approve.name)
        .get()
        .then((snap) => snap.docs.map((e) => StudentModel.fromJson(e.data())).toList()
      ..sort((a, b) => b.percentage!.compareTo(a.percentage!)));
  }

  ///=======================GET FINAL DATA ALL===================///
  static Future<List<StudentModel>> getFinalStudentDataAllFuture() {
    return _firestore
        .collectionGroup('results')
        .where('familyCode', isEqualTo: _familyCode)
        .where('isApproved', isEqualTo: true)
        .where('status', isEqualTo: StatusEnum.approve.name)
        .get()
        .then((snap) => snap.docs.map((e) => StudentModel.fromJson(e.data())).toList()
      ..sort((a, b) => b.percentage!.compareTo(a.percentage!)));
  }

  ///=======================GET BY STANDARD + STATUS===================///
  static Stream<List<StudentModel>> getStudentData({
    required String standard,
    required bool isApproved,
    required StatusEnum statusEnum,
  }) {
    final controller = StreamController<List<StudentModel>>();

    final usersRef = _firestore
        .collection('families')
        .doc(_familyCode)
        .collection('users');

    usersRef.snapshots().listen((userSnapshot) async {
      List<StudentModel> allStudents = [];

      for (final userDoc in userSnapshot.docs) {
        final resultsRef = usersRef.doc(userDoc.id).collection('results');

        final resultsSnapshot = await resultsRef
            .where('standard', isEqualTo: standard)
            .where('isApproved', isEqualTo: isApproved)
            .where('status', isEqualTo: statusEnum.name)
            .get();

        final students = resultsSnapshot.docs
            .map((doc) => StudentModel.fromJson(doc.data()))
            .toList();

        allStudents.addAll(students);
      }

      allStudents.sort((a, b) => b.percentage!.compareTo(a.percentage!));
      controller.add(allStudents);
    });

    return controller.stream;
  }



  ///=======================GET ALL STANDARD RESULTS===================///
  static Stream<List<StudentModel>> getStandardData() {
    return _firestore
        .collectionGroup('results')
        .where('familyCode', isEqualTo: _familyCode)
        .snapshots()
        .map((snap) => snap.docs.map((e) => StudentModel.fromJson(e.data())).toList());
  }

  ///=======================UPDATE STATUS===================///
  static Future<bool> updateStudentStatus(String studentId, StatusEnum status) async {
    try {
      return _updateFieldByStudentId(studentId, {
        "status": status.name,
      });
    } catch (e) {
      print('STATUS UPDATE ERROR: $e');
      return false;
    }
  }

  ///=======================DELETE STUDENT===================///
  static Future<bool> deleteStudent(String studentId) async {
    try {
      return _deleteByStudentId(studentId);
    } catch (e) {
      print('DELETE ERROR: $e');
      return false;
    }
  }

  ///=======================DELETE WITH REASON===================///
  static Future<bool> deleteStudentWithReason(
      String studentId, String reason, bool isApprove) async {
    try {
      return _updateFieldByStudentId(studentId, {
        "status": StatusEnum.delete.name,
        "reason": reason,
        "isApproved": isApprove,
      });
    } catch (e) {
      print('DELETE WITH REASON ERROR: $e');
      return false;
    }
  }

  ///=======================EDIT STUDENT===================///
  static Future<bool> studentDetailsEdit(StudentModel studentDetail) async {
    try {
      final familyCode = PreferenceManagerUtils.getFamilyCode(); // ✅

      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('users')
          .doc(studentDetail.userId)
          .collection('results')
          .doc(studentDetail.studentId); // same collection as in createStudent

      await docRef.update(studentDetail.toJson());
      return true;

    } catch (e, stackTrace) {
      print('EDIT STUDENT ERROR: $e');
      print('STACK TRACE: $stackTrace');
      return false;
    }
  }


  ///=======================APPROVE RESULT===================///
  static Future<bool> acceptStudentResult(String studentId) async {
    try {
      return _updateFieldByStudentId(studentId, {
        "isApproved": true,
        "status": StatusEnum.approve.name,
        "statusBy": PreferenceManagerUtils.getLoginAdmin(),
      });
    } catch (e) {
      print("APPROVE ERROR: $e");
      return false;
    }
  }

  ///=======================GET FINAL ALL===================///
  static Future<List<StudentModel>> getFinalAllStudentDataFuture() {
    return _firestore
        .collectionGroup('results')
        .where('familyCode', isEqualTo: _familyCode)
        .where('isApproved', isEqualTo: true)
        .where('status', isEqualTo: StatusEnum.approve.name)
        .get()
        .then((snap) => snap.docs.map((e) => StudentModel.fromJson(e.data())).toList()
      ..sort((a, b) => b.percentage!.compareTo(a.percentage!)));
  }

  // 🔁 INTERNAL: update field using collectionGroup match
  static Future<bool> _updateFieldByStudentId(String studentId, Map<String, dynamic> data) async {
    final resultSnap = await _firestore
        .collectionGroup('results')
        .where('familyCode', isEqualTo: _familyCode)
        .where('studentId', isEqualTo: studentId)
        .limit(1)
        .get();

    if (resultSnap.docs.isEmpty) return false;

    await resultSnap.docs.first.reference.update(data);
    return true;
  }

  // 🔁 INTERNAL: delete using collectionGroup match
  static Future<bool> _deleteByStudentId(String studentId) async {
    final resultSnap = await _firestore
        .collectionGroup('results')
        .where('familyCode', isEqualTo: _familyCode)
        .where('studentId', isEqualTo: studentId)
        .limit(1)
        .get();

    if (resultSnap.docs.isEmpty) return false;

    await resultSnap.docs.first.reference.delete();
    return true;
  }

  static Future<bool> updateStudent(StudentModel studentDetail) async {
    try {
      final docRef = _firestore
          .collection('families')
          .doc(studentDetail.familyCode)
          .collection('users')
          .doc(studentDetail.userId)
          .collection('results')
          .doc(studentDetail.studentId);

      await docRef.update(studentDetail.toJson());
      return true;
    } catch (e) {
      print('UPDATE STUDENT ERROR: $e');
      return false;
    }
  }
  static Future<void> migrateMissingFields() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('results')
          .get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();

        final needsUpdate = data['standard'] == null ||
            data['isApproved'] == null ||
            data['status'] == null;

        if (needsUpdate) {
          await doc.reference.set({
            if (data['standard'] == null) 'standard': '',
            if (data['isApproved'] == null) 'isApproved': false,
            if (data['status'] == null) 'status': StatusEnum.pending.name,
          }, SetOptions(merge: true));

          log('Updated missing fields for doc: ${doc.id}');
        }
      }

      log('✅ Migration completed!');
    } catch (e, st) {
      log('❌ Migration failed: $e\n$st');
    }
  }

}
