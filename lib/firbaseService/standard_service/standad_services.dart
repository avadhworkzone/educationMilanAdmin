import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/collection_utils.dart';

class StandardService {
  static Future<List<StudentModel>> getStandards() async {
    QuerySnapshot querySnapshot = await CollectionUtils.standardDetails.get();
    List<StudentModel> standardsList = querySnapshot.docs.map((doc) {
      return StudentModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    return standardsList;
  }

  static Stream<List<Map>> getStandardsStream() {
    return CollectionUtils.standardDetails
        .snapshots()
        .map((event) => event.docs.map((doc) {
              return {"id": doc.id, "standard": doc.data()['standard']};
            }).toList());
  }

  static Future<bool> addStandard(Map<String, dynamic> std) async {
    try {
      String nextId = '01';
      QuerySnapshot querySnapshot = await CollectionUtils.standardDetails.get();

      if (querySnapshot.docs.isNotEmpty) {
        List<String> documentIds =
            querySnapshot.docs.map((doc) => doc.id).toList();
        documentIds.sort((a, b) => b.compareTo(a));
        int nextIntId = int.parse(documentIds.first) + 1;
        nextId = nextIntId.toString().padLeft(2, '0'); // Ensure two digits
        log("DATA == ${nextId}");
      }
      return CollectionUtils.standardDetails
          .doc(nextId)
          .set(std)
          .then((value) => true)
          .catchError((e) {
        print('ADD STD ERROR:=>$e');
        return false;
      });
    } catch (e) {
      log('ADD STD ERROR :=>$e');
      return false;
    }
  }

  static Future<bool> editStandard(
      String standardId, Map<String, dynamic> updateStandard) async {
    try {
      await CollectionUtils.standardDetails
          .doc(standardId)
          .update(updateStandard);
      return true;
    } catch (e) {
      log('EDIT STD ERROR :=>$e');
      return false;
    }
  }

  static Future<bool> deleteStandard(String standardId) async {
    try {
      await CollectionUtils.standardDetails.doc(standardId).delete();
      return true;
    } catch (e) {
      print('DELETE STD ERROR: $e');
      return false;
    }
  }
}
