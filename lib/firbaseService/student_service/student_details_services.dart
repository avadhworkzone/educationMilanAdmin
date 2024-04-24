import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/model/user_model.dart';
import 'package:responsivedashboard/utils/collection_utils.dart';
import 'package:responsivedashboard/utils/enum_utils.dart';

class StudentService {
  ///=======================GET FINAL DATA IN FUTURE===================///
  static Future<List<StudentModel>> getFinalStudentDataFuture(
      {required String standard}) {
    return CollectionUtils.studentDetails
        .where('standard', isEqualTo: standard)
        .where('isApproved', isEqualTo: true)
        .where('status', isEqualTo: StatusEnum.approve.name)
        .get()
        .then((event) =>
            event.docs.map((e) => StudentModel.fromJson(e.data())).toList()
              ..sort((a, b) => b.percentage!.compareTo(a.percentage!)));
  }

  ///=======================get data===================///
  static Stream<List<StudentModel>> getStudentData(
      {required String standard,
      required bool isApproved,
      required StatusEnum statusEnum}) {
    return CollectionUtils.studentDetails
        .where('standard', isEqualTo: standard)
        .where('isApproved', isEqualTo: isApproved)
        .where('status', isEqualTo: statusEnum.name)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => StudentModel.fromJson(e.data())).toList()
              ..sort((a, b) => b.percentage!.compareTo(a.percentage!)));
  }

  ///=======================get Standard===================///
  static Stream<List<StudentModel>> getStandardData() {
    return CollectionUtils.standardDetails.snapshots().map((event) =>
        event.docs.map((e) => StudentModel.fromJson(e.data())).toList());
  }

  ///=======================delete data===================///
  static Future<bool> deleteStudent(String studentId) async {
    try {
      await CollectionUtils.studentDetails.doc(studentId).delete();
      return true;
    } catch (e) {
      print('DELETE ERROR :=> $e');
      return false;
    }
  }

  ///=======================DELETE USER WITH REASON===================///
  static Future<bool> deleteStudentWithReason(
      String studentId, String reason, bool isApprove) async {
    try {
      // await CollectionUtils.studentDetails.doc(studentId).delete();
      await CollectionUtils.studentDetails.doc(studentId).set({
        "status": StatusEnum.delete.name,
        "reason": reason,
        "isApproved": isApprove
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('DELETE ERROR :=> $e');
      return false;
    }
  }

  ///=======================STATUS USER===================///
  static Future<bool> updateStudentStatus(
      String studentId, StatusEnum status) async {
    try {
      await CollectionUtils.studentDetails
          .doc(studentId)
          .set({"status": status.name}, SetOptions(merge: true));
      return true;
    } catch (e) {
      print('DELETE ERROR :=> $e');
      return false;
    }
  }

  ///=======================update data===================///
  static Future<bool> studentDetailsEdit(StudentModel studentDetail) async {
    // final doc = CollectionUtils.studentDetails.doc(studentDetail.studentId);

    return CollectionUtils.studentDetails
        .doc(studentDetail.studentId)
        .update(studentDetail.toJson())
        .then((value) => true)
        .catchError((e) {
      print('APPOINTMENT UPDATE ERROR :=>$e');
      return false;
    });
  }

  ///accept the result and remove from desktop

  static Future<bool> acceptStudentResult(String studentId) async {
    try {
      await CollectionUtils.studentDetails
          .doc(studentId)
          .update({"isApproved": true, "status": StatusEnum.approve.name});

      return true; // Update successful
    } catch (e) {
      print("Accept result error: $e");
      return false; // Update failed
    }
  }
}
