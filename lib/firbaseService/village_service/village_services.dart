import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsivedashboard/model/student_model.dart';
import 'package:responsivedashboard/utils/collection_utils.dart';

import '../../utils/share_preference.dart';

class VillageService {
  static String get _familyCode => PreferenceManagerUtils.getFamilyCode();
  Future<List<String>> getVillagesByFamily() async {
    List<String> villageList = []; // ✅ Add this here

    try {
      final doc = await FirebaseFirestore.instance
          .collection('families')
          .doc(_familyCode) // ✅ use globally saved _familyCode
          .collection('village')
          .doc('villages')
          .get();

      if (doc.exists) {
        List<dynamic> data = doc.data()?['villages'] ?? [];
        villageList = data.map((e) => e.toString()).toList();
      } else {
        villageList = [];
      }
      return villageList;
    } catch (e) {
      print('Error fetching villages: $e');
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

  Future<List<StudentModel>> getVillages() async {
    QuerySnapshot querySnapshot = await CollectionUtils.villageDetails.get();
    List<StudentModel> villageList = querySnapshot.docs.map((doc) {
      return StudentModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    return villageList;
  }

  Stream<List<StudentModel>> getVillagesStream() {
    return CollectionUtils.villageDetails
        .snapshots()
        .map((event) => event.docs.map((doc) {
              return StudentModel.fromJson(doc.data());
            }).toList());
  }

  static Future<bool> addVillage(String newVillage) async {
    try {
      final familyCode = _familyCode; // Use your login family code

      final docRef = FirebaseFirestore.instance
          .collection('families')
          .doc(familyCode)
          .collection('village')
          .doc('villages');

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        List<dynamic> existingVillages = snapshot.data()?['villages'] ?? [];

        if (!existingVillages.contains(newVillage)) {
          existingVillages.add(newVillage);

          await docRef.update({
            'villages': existingVillages,
          });
        }
      } else {
        // If no document exists, create new
        await docRef.set({
          'villages': [newVillage],
        });
      }
      return true;
    } catch (e) {
      print('Error adding village: $e');
      return false;
    }
  }

  static Future<bool> editVillage(
      String villageId, Map<String, dynamic> updateVillage) async {
    try {
      await CollectionUtils.villageDetails.doc(villageId).update(updateVillage);
      return true;
    } catch (e) {
      log('EDIT VILLAGE ERROR :=>$e');
      return false;
    }
  }

  static Future<bool> deleteVillage(String villageId) async {
    try {
      await CollectionUtils.villageDetails.doc(villageId).delete();
      return true;
    } catch (e) {
      print('DELETE VILLAGE ERROR: $e');
      return false;
    }
  }
}
