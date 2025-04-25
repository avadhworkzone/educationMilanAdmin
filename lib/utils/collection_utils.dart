import 'package:cloud_firestore/cloud_firestore.dart';
class TextConfig {
  static const admin = 'AdminDetails';
  static const studentDetails = 'StudentDetails';
  static const userDetails = 'UserDetails';
  static const standardList = 'standardList';
  static const villageList = 'villageList';
  static const families = 'families'; // ✅ NEW
}

class CollectionUtils {
  static final adminCollection = FirebaseFirestore.instance.collection(TextConfig.admin);
  static final studentDetails = FirebaseFirestore.instance.collection(TextConfig.studentDetails);
  static final standardDetails = FirebaseFirestore.instance.collection(TextConfig.standardList);
  static final villageDetails = FirebaseFirestore.instance.collection(TextConfig.villageList);
  static final userDetails = FirebaseFirestore.instance.collection(TextConfig.userDetails);
  static final families = FirebaseFirestore.instance.collection(TextConfig.families); // ✅ NEW
}
