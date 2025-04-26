import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/collection_utils.dart';
import 'package:responsivedashboard/utils/share_preference.dart';

class StandardService {

  static String get _familyCode => PreferenceManagerUtils.getFamilyCode();
  static Future<List<String>> getStandardsByFamily(String familyCode) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('standerd')
          .doc('standerd')
          .get();

      if (doc.exists) {
        List<dynamic> data = doc['standerd'] ?? [];
        return data.map((e) => e.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching standards: $e');
      return [];
    }
  }
  Future<bool> deleteVillageByName(String villageName) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(_familyCode)
          .collection('village')
          .doc('villages');

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<dynamic> villages = docSnapshot.data()?['villages'] ?? [];

        villages.removeWhere((item) => item.toString().trim() == villageName.trim());

        await docRef.update({'villages': villages});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting village: $e');
      return false;
    }
  }

  static Future<bool> deleteStandardByName(String standardName) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(_familyCode)
          .collection('standerd')
          .doc('standerd');

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<dynamic> standards = docSnapshot.data()?['standerd'] ?? [];

        standards.removeWhere((item) => item.toString().trim() == standardName.trim());

        await docRef.update({'standerd': standards});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting standard: $e');
      return false;
    }
  }

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

  static Future<bool> addStandard(String newStandard) async {
    try {
      final familyCode = _familyCode; // or wherever you store logged-in familyCode

      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('standerd')
          .doc('standerd');

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        List<dynamic> existingStandards = snapshot.data()?['standerd'] ?? [];

        if (!existingStandards.contains(newStandard)) {
          existingStandards.add(newStandard);

          await docRef.update({
            'standerd': existingStandards,
          });
        }
      } else {
        // If no standerd document, create one
        await docRef.set({
          'standerd': [newStandard],
        });
      }
      return true;
    } catch (e) {
      print('Error adding standard: $e');
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
